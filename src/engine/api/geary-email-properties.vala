/* Copyright 2011 Yorba Foundation
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution. 
 */

public abstract class Geary.EmailProperties : Object {
    public EmailProperties() {
    }
    
    public abstract bool is_unread();
}
