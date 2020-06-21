--铠武龙 什锦将军
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(25000061)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_PENDULUM),aux.NonTuner(Card.IsSynchroType,TYPE_PENDULUM),1)
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_PZONE,nil,nil,rsop.target(rscf.spfilter2(cm.spfilter),"sp",rsloc.de),cm.spop)
	local e2=rsef.I(c,{m,1},{1,m},nil,nil,LOCATION_PZONE,nil,nil,rsop.target(cm.setfilter,nil,rsloc.de),cm.setop)
	local e3=rsef.I(c,{m,2},{1,m+100},"des,sp","tg",LOCATION_PZONE,nil,nil,rstg.target({cm.desfilter,"des",LOCATION_ONFIELD,0,1,1,c },rsop.list(rscf.spfilter2(),"sp")),cm.spop2)
	local e4=rsef.QO(c,nil,{m,3},{1,m+200},nil,nil,LOCATION_MZONE,nil,cm.cpcost,nil,cm.cpop)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,5))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(cm.pencon)
	e5:SetTarget(cm.pentg)
	e5:SetOperation(cm.penop)
	c:RegisterEffect(e5)
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_DECK) or c:IsFaceup())
end
function cm.spop(e,tp)
	if not aux.ExceptThisCard(e) then return end
	rsop.SelectSpecialSummon(tp,rscf.spfilter2(cm.spfilter),tp,rsloc.de,0,1,1,nil,{},e,tp)
end
function cm.setfilter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_DECK) or c:IsFaceup()) and not c:IsForbidden() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
end
function cm.setop(e,tp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.setfilter,tp,rsloc.de,0,1,1,nil):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function cm.desfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.spop2(e,tp)
	local c,tc=aux.ExceptThisCard(e),rscf.GetTargetCard()
	if tc and Duel.Destroy(tc,REASON_EFFECT)>0 and c then
		rssf.SpecialSummon(c)
	end 
end
function cm.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tefilter,tp,LOCATION_DECK,0,1,nil) end
	rshint.Select(tp,"td")
	local tc=Duel.SelectMatchingCard(tp,cm.tefilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	Duel.SendtoExtraP(tc,nil,REASON_COST)
	e:SetLabelObject(tc)
end
function cm.cpop(e,tp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local code=tc:GetOriginalCodeRule()
	local atk,def=tc:GetAttack()/2,tc:GetDefense()/2
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if not tc:IsType(TYPE_TRAPMONSTER) then
			local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		end
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(m,4))
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCountLimit(1)
		e3:SetRange(LOCATION_MZONE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetLabelObject(e1)
		e3:SetLabel(cid)
		e3:SetOperation(cm.rstop)
		c:RegisterEffect(e3)
		local e4,e5=rscf.QuickBuff(c,"atk+,def+",{atk,def},"reset",rsreset.est_pend)
	end
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end