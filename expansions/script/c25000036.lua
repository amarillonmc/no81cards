--节肢型异生兽 班匹拉
if not pcall(function() require("expansions/script/c25000033") end) then require("script/c25000033") end
local m,cm=rscf.DefineCard(25000036)
function cm.initial_effect(c)
	rssb.SummonCondition(c)  
	local e1=rsef.I(c,{m,0},{1,m},"rm,th,se",nil,LOCATION_HAND,rssb.cfcon,nil,cm.tg,cm.op)
	local e2=rsef.QO(c,nil,{m,2},{1,m+100},"pos",nil,LOCATION_MZONE,nil,rssb.rmtdcost(1),rsop.target(cm.posfilter,"pos",0,LOCATION_MZONE,true,true),cm.posop)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return #g==3 and g:FilterCount(Card.IsAbleToRemove,nil,POS_FACEDOWN)==3 and c:IsAbleToRemove(POS_FACEDOWN) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function cm.filter(c)
	return c:IsAbleToHand() and rssb.IsSetM(c)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,3)
	if #g~=3 or g:FilterCount(Card.IsAbleToRemove,nil,POS_FACEDOWN)~=3 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if #g>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(cm.filter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,cm.filter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		local c=aux.ExceptThisCard(e)
		if c then g:AddCard(c) end
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_REVEAL)
	end
end
function cm.posfilter(c)
	return c:IsAttackPos() and c:IsCanChangePosition()
end
function cm.posop(e,tp)
	local g=Duel.GetMatchingGroup(cm.posfilter,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	end
end
