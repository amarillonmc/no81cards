--薮猫 ～踏上新的未知旅程～
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=33700940
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,2,true)
	local e1=rscf.SetSpecialSummonProduce(c,LOCATION_EXTRA,cm.con,cm.op)
	local f1=function(tp,re,rp)
		return tp~=rp
	end
	local e2=rsef.QO(c,EVENT_CHAINING,{m,0},1,"tg,des,neg","dsp,dcal",LOCATION_MZONE,rscon.negcon(f1),nil,cm.tg2,cm.op2)
	local f2=function(e)
		local g=Duel.GetMatchingGroup(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,0x442)
		return g:GetClassCount(Card.GetCode)>=15
	end
	local e3=rsef.FV_INDESTRUCTABLE(c,"battle")
	e3:SetCondition(f2)
	local e4=rsef.FV(c,EFFECT_AVOID_BATTLE_DAMAGE,1,nil,{1,0},LOCATION_MZONE,f2,nil,"ptg")
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
		return g:FilterCount(Card.IsAbleToGrave,nil)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetDecktopGroup(tp,15)
	Duel.ConfirmDecktop(tp,15)
	local codect=rg:GetClassCount(Card.GetCode)
	if #rg<=0 or codect<#rg then return end
	local f=function(rc)
		return rc:IsSetCard(0x442) and rc:IsAbleToGrave()
	end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and rg:IsExists(f,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=rg:FilterSelect(tp,f,1,1,nil)
		if Duel.SendtoGrave(tg,REASON_EFFECT)~=0 then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end