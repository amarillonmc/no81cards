--小包 ～踏上新的未知旅程～
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=33700939
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,2,true)
	local e1=rscf.SetSpecialSummonProduce(c,LOCATION_EXTRA,cm.con,cm.op)
	local e2=rsef.I(c,{m,0},{1,m},"tg,th,se",nil,LOCATION_MZONE,nil,nil,cm.tg2,cm.op2)
end
function cm.con(e,c)
	if not c then return true end
	local tp=c:GetControler()
	local f=function(rc)
		return rc:IsSetCard(0x442) and rc:IsType(TYPE_MONSTER)
	end
	local f2=function(rc,p)
		return Duel.GetLocationCountFromEx(p,p,rc)>0 and rc:IsSetCard(0x442)
	end
	local g=Duel.GetMatchingGroup(f,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=5 and Duel.CheckReleaseGroup(tp,f2,1,nil,tp)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,c)
	local f=function(rc,p)
		return Duel.GetLocationCountFromEx(p,p,rc)>0 and rc:IsSetCard(0x442)
	end
	local g=Duel.SelectReleaseGroup(tp,f,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function cm.ffilter(c,fc,sub,mg,sg)
	return not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode())
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<15 then return false end
		local g=Duel.GetDecktopGroup(tp,15)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=aux.ExceptThisCard(e)
	local rg=Duel.GetDecktopGroup(tp,15)
	Duel.ConfirmDecktop(tp,15)
	local codect=rg:GetClassCount(Card.GetCode)
	if #rg<=0 then return end
	if codect<#rg and c then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	local g1=rg:Filter(Card.IsAbleToHand,nil)
	local g2=g1:Filter(Card.IsSetCard,nil,0x442)
	if #g1<=0 and #g2<=0 then return end
	local op=rsof.SelectOption(tp,true,aux.Stringid(m,1),#g1>0,aux.Stringid(m,2),#g2>0,aux.Stringid(m,3))
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	if op==2 then   
		g=g1:Select(tp,1,1,nil)
	elseif op==3 then
		g=g2:Select(tp,1,3,nil)
	end
	if g then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		g1:Sub(g)
		local g3=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x442)
		if g3:GetClassCount(Card.GetCode)>=15 and #g1>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			 local g4=g1:Select(tp,1,1,nil)
			 Duel.BreakEffect()
			 Duel.SendtoHand(g4,nil,REASON_EFFECT)
			 Duel.ConfirmCards(1-tp,g4)
		end
	end  
end
