--砂之星之降诞
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=33700945
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"th,tg",nil,nil,nil,cm.tg,cm.op)
	local f=function(rc,e,tp)
		return rc:GetTurnID()==Duel.GetTurnCount() and rc:IsReason(REASON_BATTLE+REASON_EFFECT) and rc:IsReason(REASON_DESTROY) and rc:GetReasonPlayer()~=tp and rc:IsType(TYPE_MONSTER) and rc:IsSetCard(0x442)
	end
	local e2=rsef.QO(c,nil,{m,3},nil,"th","tg",LOCATION_GRAVE,nil,aux.bfgcost,rstg.target(f,"th",LOCATION_GRAVE,0,1,1),cm.op2)
end
function cm.op2(e)
	local g=rsgf.GetTargetGroup()
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,7)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.filter(c)
	return (c:IsSetCard(0x104) and c:IsType(TYPE_MONSTER)) or c:IsSetCard(0xfe)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,7)
	local g=Duel.GetDecktopGroup(tp,7)
	if #g<=0 then return end
	if g:GetClassCount(Card.GetCode)<#g then Duel.ShuffleDeck(tp) return end
	local f=function(c,ctype)
		return c:IsAbleToHand() and c:IsSetCard(0x442) and (not ctype or c:IsType(ctype))
	end
	local b1=g:IsExists(f,1,nil)
	local b2=g:FilterCount(f,nil,TYPE_MONSTER)==#g and #g>=3
	local b3=b2 and Duel.IsPlayerCanDiscardDeck(tp,#g) and #g>=4
	if not b1 and not b2 and not b3 then return end
	local op=rsof.SelectOption(tp,b1,{m,0},b2,{m,1},b3,{m,2})
	if op>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg1=g:FilterSelect(tp,f,1,1,nil)
		Duel.SendtoHand(tg1,nil,tp)
		Duel.ConfirmCards(1-tp,tg1)
		g:Sub(tg1)
	end
	if op>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)   
		local tg2=g:FilterSelect(tp,f,2,2,nil,TYPE_MONSTER)
		Duel.SendtoHand(tg2,nil,tp)
		Duel.ConfirmCards(1-tp,tg2)
		g:Sub(tg2)
	end
	if op==3 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	Duel.ShuffleDeck(tp)
end

