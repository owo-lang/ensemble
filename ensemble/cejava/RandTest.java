/**************************************************************/
/* JavaTest.JAVA: performance test. */
/* Author: Ohad Rodeh 7/2002 */
/* Stress tests joins/leave/send/casts/etc. */
/* Similar to ce/ce_rand and demo/rand */
/**************************************************************/
import java.lang.* ;
import java.io.* ;
import java.util.* ; 
import ensemble.*;
/**************************************************************/

public class RandTest
{
    static int nmembers = 2;
    static int thresh = 2;
    static final String groupName = "GroupA";
    static Random rand = new Random ();
    
    static void sleep(int milliseconds) {
	try {
	    Thread.sleep(milliseconds);
	} catch(Exception e) { e.printStackTrace(); }
    }
    
    static JoinOps create_JoinOps() {
	JoinOps jops = new JoinOps();
	jops.group_name = groupName;
	jops.hrtbt_rate = 10.0 ;
	return jops;
    }
    
    /* Class variables
     */
    Group g;
    int my_rank;
    int my_nmembers;
    Thread test_thread = null;
    
    static RandTest create_endpt() {
	System.out.println("create_endpt");
	System.out.flush();
	
	JoinOps jops = create_JoinOps();
	final RandTest x = new RandTest ();
	final Group group = new Group(new Callbacks() {
		public void install(View view) {
		    x.my_rank = view.rank;
		    x.my_nmembers = view.nmembers;
		    System.out.println("RandTest: Install:{");
		    
		    System.out.println("  version= " + view.version);
		    System.out.println("  proto= " + view.proto);
		    System.out.println("  group= " + view.group);
		    System.out.println("  coord= " + view.coord);
		    System.out.println("  ltime= " + view.ltime);
		    System.out.println("  primary= " + view.primary);
		    System.out.println("  groupd= " + view.groupd);
		    System.out.println("  xfer_view= " + view.xfer_view);
		    System.out.println("  params= " + view.params);
		    System.out.println("  uptime= " + view.uptime);
		    System.out.println("  view= " + 
				       java.util.Arrays.asList(view.view));
		    System.out.println("  address= " + 
				       java.util.Arrays.asList(view.address));
		    System.out.println("  endpt= " + view.endpt);
		    System.out.println("  addr= " + view.addr);
		    System.out.println("  name= " + view.name);
		    System.out.println("  nmembers= " + view.nmembers);
		    System.out.println("  am_coord= " + view.am_coord);
		    
		    System.out.println("}");
		}

		public void exit() {
		    System.out.println("RT exit");
		    System.out.flush();

		    new Thread() { public void run() {
			try {
			    Thread.sleep(1000);
			    create_endpt ();
			} catch(Exception e) { e.printStackTrace(); }
		    }}.start();
		}
		
		public void recv_cast(int origin, byte[] msg) {
		    System.out.println("RT recv_cast: " +
				       new String(msg)+" from "+ origin);
		}
		
		public void recv_send(int origin, byte[] msg) {
                    System.out.println("RT recv_send: " +
		    	               new String(msg) + " from " + origin);
		}
		
		public void flow_block(int rank, boolean onoff) {}

		public void block() {
		    System.out.println("RT blocked");
		}
		
		public void heartbeat(double time) {
		    System.out.println("RandTest: heartbeat " + time);
		    System.out.flush();
		    //try {
		    //   exec(x);
		    //} catch(Exception e) { e.printStackTrace(); }
		}
	    });
	x.g = group;
	group.join(jops);
	System.out.println("******* JOIN " + x.g.nat_env + "**********************");
	sleep(500);
	
        x.test_thread = new Thread() { public void run() {
	    try {
		while(true) {
		    Thread.sleep(500);
		    System.out.flush ();
		    synchronized (x.g) {
			int status = x.g.getStatus ();
			if (status == Group.LEFT)
			    return;
			if (status == Group.NORMAL
			    && x.my_nmembers >= thresh)
			    x.exec();
		    }
		}
	    } catch(Exception e) { e.printStackTrace(); }
	}};
        x.test_thread.start();

	return x;
    }


    static byte[] gen_msg (){
	String s = "Hello World";
	return s.getBytes ();
    }
    
    static int gen_dest (int rank, int nmembers) {
	int rep = rank;
	
	if (nmembers == 1) {
	    System.out.println("gen_dest in a group of size 1");
	    System.exit(1);
	}
	while (rep == rank) {
	    rep = (Math.abs(rand.nextInt ())) % nmembers;
	}
	/*	System.out.println("dest=" + rep + "  me=" + rank);
	if (rep == rank) {
	    System.out.println("dest == me !");
	    System.exit(1);
	    }*/
	return rep;
    }

    static int[] gen_dests(int rank, int nmembers){
	int[] a = new int[2];
	a[0] = gen_dest(rank, nmembers); 
	a[1] = gen_dest(rank, nmembers); 
	return a;
    }
    
    void exec() {
	int p = (Math.abs(rand.nextInt ())) % 100;
        String action = null;
/*	
	System.out.println("Prompt");System.out.flush();
	g.prompt();
*/
	
	System.out.print(g.nat_env + " action = < ");
	System.out.flush();
	//	System.out.println("status" + status.intValue());

	if (p < 6) {
	    action = "Leave";
	    System.out.println("******* LEAVE " + g.nat_env + "**********************");
	    g.leave();
	} else  if (p < 9) {
	    action = "Prompt";
	    System.out.println("Prompt");System.out.flush();
	    g.prompt();
	}  else if (p < 15) {
	    action = "Suspect";
	    g.suspect(gen_dests(my_rank, my_nmembers));
	    //	} else if (p < 20) {
	    //	    action = "Protocol";
        } else if (p < 25) {
	    action = "Properties";
	    String vsync = "Gmp:Sync:Heal:Frag:Suspect:Flow:Slander" ;
	    String props = null;
	    int i = (Math.abs (rand.nextInt ())) % 5;
	    switch (i) {
	    case 0: props = vsync; break;
	    case 1: props = vsync + ":causal"; break;
	    case 2: props = vsync + ":total"; break;
	    case 3: props = vsync + ":scale"; break;
	    case 4: props = vsync + ":local"; break;
	    default:
		System.out.println("bad random value, abort, i=" + i);
		System.exit(1);
	    }
	    g.changeProperties(props);
	} else if (p < 40) {
	    action = "Cast";
	    g.cast(gen_msg());
	} else if (p < 70) {
	    action = "Send1";
	    g.send1(gen_dest(my_rank, my_nmembers), gen_msg());
	} else {
	    action = "Send";
	    g.send(gen_dests(my_rank, my_nmembers), gen_msg());
	}  
    
	System.out.println(action + ">");
	System.out.flush();
    }
    
    /* Parse command line arguments. 
     */    
    static String[] parse_cmd_line(String[] args) {
	int len=0;
	
	for (int i = 0; i < args.length; i++) {
	    if (args[i].equals("-t")) {
		//		System.out.println("in -t");
		thresh = Integer.parseInt(args[i+1]);
		System.out.println("thresh = " + thresh);
		args[i] = null;
		args[i+1] = null;
		i++;
	    } else if (args[i].equals("-n")) {
		//		System.out.println("in -n");		
		nmembers = Integer.valueOf(args[i+1]).intValue();
		System.out.println("nmembers = " + nmembers);
		args[i] = null;
		args[i+1] = null;
		i++;
	    } else len++;
	}

	String[] new_args = new String[len];
	for(int i=0, j=0; i<args.length; i++) {
	    if (args[i] != null) {
		new_args[j] = args[i];
		j++;
	    }
	}
	
	return new_args;
    }

    /** A simple test case. Invoke with a number of group names.
     * Each member will cast the group name every second.
     */
    public static void main(final String args[]) throws Exception {
	String new_args [] = parse_cmd_line (args);
	Group.init(new_args);
	for(int i=0; i<nmembers; i++)
	    create_endpt ();
    }
}