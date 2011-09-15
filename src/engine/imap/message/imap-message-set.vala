/* Copyright 2011 Yorba Foundation
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution. 
 */

public class Geary.Imap.MessageSet {
    public bool is_uid { get; private set; default = false; }
    
    private string value { get; private set; }
    
    public MessageSet(int msg_num) {
        assert(msg_num > 0);
        
        value = "%d".printf(msg_num);
    }
    
    public MessageSet.uid(UID uid) {
        assert(uid.value > 0);
        
        value = "%lld".printf(uid.value);
        is_uid = true;
    }
    
    public MessageSet.range(int low_msg_num, int count) {
        assert(low_msg_num > 0);
        assert(count > 0);
        
        value = (count > 1)
            ? "%d:%d".printf(low_msg_num, low_msg_num + count - 1)
            : "%d".printf(low_msg_num);
    }
    
    public MessageSet.uid_range(UID low, UID high) {
        assert(low.value > 0);
        assert(high.value > 0);
        
        value = "%lld:%lld".printf(low.value, high.value);
        is_uid = true;
    }
    
    public MessageSet.range_to_highest(int low_msg_num) {
        assert(low_msg_num > 0);
        
        value = "%d:*".printf(low_msg_num);
    }
    
    public MessageSet.uid_range_to_highest(UID low) {
        assert(low.value > 0);
        
        value = "%lld:*".printf(low.value);
        is_uid = true;
    }
    
    public MessageSet.sparse(int[] msg_nums) {
        value = build_sparse_range(msg_nums);
    }
    
    public MessageSet.sparse_to_highest(int[] msg_nums) {
        value = "%s:*".printf(build_sparse_range(msg_nums));
    }
    
    public MessageSet.multirange(MessageSet[] msg_sets) {
        StringBuilder builder = new StringBuilder();
        for (int ctr = 0; ctr < msg_sets.length; ctr++) {
            unowned MessageSet msg_set = msg_sets[ctr];
            
            if (ctr < (msg_sets.length - 1))
                builder.append_printf("%s:", msg_set.value);
            else
                builder.append(msg_set.value);
        }
        
        value = builder.str;
    }
    
    public MessageSet.multisparse(MessageSet[] msg_sets) {
        StringBuilder builder = new StringBuilder();
        for (int ctr = 0; ctr < msg_sets.length; ctr++) {
            unowned MessageSet msg_set = msg_sets[ctr];
            
            if (ctr < (msg_sets.length - 1))
                builder.append_printf("%s,", msg_set.value);
            else
                builder.append(msg_set.value);
        }
        
        value = builder.str;
    }
    
    public MessageSet.custom(string custom) {
        value = custom;
    }
    
    public MessageSet.uid_custom(string custom) {
        value = custom;
        is_uid = true;
    }
    
    // TODO: It would be more efficient to look for runs in the numbers and form the set specifier
    // with them.
    private static string build_sparse_range(int[] msg_nums) {
        assert(msg_nums.length > 0);
        
        StringBuilder builder = new StringBuilder();
        for (int ctr = 0; ctr < msg_nums.length; ctr++) {
            int msg_num = msg_nums[ctr];
            assert(msg_num >= 0);
            
            if (ctr < (msg_nums.length - 1))
                builder.append_printf("%d,", msg_num);
            else
                builder.append_printf("%d", msg_num);
        }
        
        return builder.str;
    }
    
    public Parameter to_parameter() {
        // Message sets are not quoted, even if they use an atom-special character (this *might*
        // be a Gmailism...)
        return new UnquotedStringParameter(value);
    }
    
    public string to_string() {
        return value;
    }
}
