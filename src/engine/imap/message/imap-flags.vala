/* Copyright 2011-2014 Yorba Foundation
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution.
 */

/**
 * A generic collection of {@link Flags}.
 */

public abstract class Geary.Imap.Flags : Geary.MessageData.AbstractMessageData, Geary.Imap.MessageData,
    Gee.Hashable<Geary.Imap.Flags> {
    public int size { get { return list.size; } }
    
    protected Gee.Set<Flag> list;
    
    public Flags(Gee.Collection<Flag> flags) {
        list = new Gee.HashSet<Flag>();
        list.add_all(flags);
    }
    
    public bool contains(Flag flag) {
        return list.contains(flag);
    }
    
    public Gee.Set<Flag> get_all() {
        return list.read_only_view;
    }
    
    /**
     * Returns the flags in serialized form, which is each flag separated by a space (legal in
     * IMAP, as flags must be atoms and atoms prohibit spaces).
     */
    public virtual string serialize() {
        return to_string();
    }
    
    /**
     * Returns a {@link ListParameter} representation of these flags.
     *
     * If empty, this returns an empty ListParameter.
     */
    public virtual Parameter to_parameter() {
        ListParameter listp = new ListParameter();
        foreach (Flag flag in list)
            listp.add(flag.to_parameter());
        
        return listp;
    }
    
    public bool equal_to(Geary.Imap.Flags other) {
        if (this == other)
            return true;
        
        if (other.size != size)
            return false;
        
        return Geary.traverse<Flag>(list).all(f => other.contains(f));
    }
    
    public override string to_string() {
        StringBuilder builder = new StringBuilder();
        foreach (Flag flag in list) {
            if (!String.is_empty(builder.str))
                builder.append_c(' ');
            
            builder.append(flag.value);
        }
        
        return builder.str;
    }
    
    public uint hash() {
        return to_string().down().hash();
    }
}

