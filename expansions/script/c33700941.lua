--动物朋友 北狐 ～雪～
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=33700941
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	local e1=rsef.SV_LIMIT(c,"ress")
	local e2=rsef.SV_LIMIT(c,"resns")
	local e3=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},1)
	e3:SetOperation(function(e,tp)
		local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		if #g>0 then Duel.ConfirmCards(1-tp,g) end
		if g:GetClassCount(Card.GetCode)<#g then return end
		local rc=rscf.GetRelationCard(e)
		if rc then
			e:GetLabelObject():SetLabel(1)
		end
	end)
	local f1=function(tp)
		local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
		return g:GetClassCount(Card.GetCode)==#g
	end
	local e4=rsef.QO(c,EVENT_CHAINING,{m,0},1,"rm,neg","dsp,dcal",LOCATION_MZONE,rscon.negcon(f1),nil,cm.tg,cm.op)
	e3:SetLabelObject(e4)
	local f2=function(e)
		return Duel.GetCurrentChain()==0
	end
	local e4=rsef.QO(c,EVENT_SPSUMMON,{m,0},1,"rm,diss",nil,LOCATION_MZONE,f2,nil,cm.tg2,cm.op2)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() and e:GetLabel()==1 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end