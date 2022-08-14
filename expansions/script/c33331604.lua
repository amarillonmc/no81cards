--天基兵器 紫微之极光
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c33330048") end) then require("script/c33330048") end
function cm.initial_effect(c)
	local e1,e2 = Rule_SpaceWeapon.initial(c,m,cm.op)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.BreakEffect()
	Duel.Recover(tp,2000,REASON_EFFECT)
	local n=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if n==0 then return end
	n=Duel.GetDecktopGroup(tp,n>1 and 2 or 1)
	if Duel.IsPlayerCanDraw(tp,#n) then 
		Duel.Draw(tp,#n,REASON_EFFECT)
	end
	n=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if n==0 then return end
	n=Duel.GetDecktopGroup(tp,n>1 and 2 or 1)
	if Duel.IsPlayerCanDiscardDeck(tp,#n) then 
		Duel.DiscardDeck(tp,#n,REASON_EFFECT)
	end
	n=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if n==0 then return end
	n=Duel.GetDecktopGroup(tp,n>1 and 2 or 1)
	if n:FilterCount(Card.IsAbleToRemove,nil,POS_FACEUP)==#n then 
		Duel.Remove(n,POS_FACEUP,REASON_EFFECT)
	end
end