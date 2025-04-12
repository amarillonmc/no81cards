local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,id+500)
	e2:SetCondition(s.pcon)
	e2:SetTarget(s.ptg)
	e2:SetOperation(s.pop)
	c:RegisterEffect(e2)
end
function s.thfilter1(c,tp)
	return c:IsSetCard(0xc8) and c:IsLevelAbove(7) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c)
end
function s.thfilter2(c)
	return c:IsSetCard(0xc8) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,g1:GetFirst())
		g1:Merge(g2)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end
function s.pcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function s.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetUsableMZoneCount(tp)<=0 then return false end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.pendvalue)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local eset={e1}
		local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,0xc8)
		local res=g:IsExists(aux.PConditionFilter,1,nil,e,tp,1,7,eset)
		e1:Reset()
		return res
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.pendvalue(e,c)
	return c:IsSetCard(0xc8)
end
function s.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.pendvalue)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local eset={e1}
	local ft=Duel.GetUsableMZoneCount(tp)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<ft then ft=ect end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local tg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,0xc8)
	tg=tg:Filter(aux.PConditionFilter,nil,e,tp,1,7,eset)
	tg=tg:Filter(aux.PConditionExtraFilterSpecific,nil,e,tp,1,7,e1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.GCheckAdditional=aux.PendOperationCheck(6,6,ft)
	local g=tg:SelectSubGroup(tp,aux.TRUE,false,1,math.min(#tg,ft))
	aux.GCheckAdditional=nil
	if not g then
		e1:Reset()
		return
	end
	local sg=Group.CreateGroup()
	sg:Merge(g)
	Duel.HintSelection(Group.FromCards(lpz))
	Duel.HintSelection(Group.FromCards(rpz))
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_TOMAIN_KOISHI)
	e2:SetTargetRange(LOCATION_EXTRA,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc8))
	Duel.RegisterEffect(e2,tp)
	sg:KeepAlive()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC_G)
	e3:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e3:SetLabelObject(sg)
	e3:SetOperation(s.op)
	e3:SetValue(SUMMON_TYPE_PENDULUM|id)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	sg:GetFirst():RegisterEffect(e3,true)
	local e4=Effect.CreateEffect(c)
	local e5=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_NEGATED)
	e4:SetOperation(s.reset1(e1,e2,e5))
	e4:SetReset(RESET_EVENT+id)
	Duel.RegisterEffect(e4,tp)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetLabelObject(sg)
	e5:SetOperation(s.reset2(e1,e2,e4,e))
	Duel.RegisterEffect(e5,tp)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	e6:SetTarget(s.splimit)
	e6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e6,tp)
	Duel.HintSelection(Group.FromCards(lpz))
	Duel.HintSelection(Group.FromCards(rpz))
	Duel.SpecialSummonRule(tp,sg:GetFirst(),SUMMON_TYPE_PENDULUM|id)
end
function s.splimit(e,c)
	return not c:IsSetCard(0xc8)
end
function s.op(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	sg:Merge(e:GetLabelObject())
end
function s.reset1(e1,e2,e5)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				e1:Reset() e2:Reset() e5:Reset() e:Reset()
			end
end
function s.reset2(e1,e2,e4,es)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				Duel.RaiseEvent(e:GetLabelObject(),EVENT_SPSUMMON_SUCCESS_G_P,es,REASON_EFFECT,tp,tp,0)
				e1:Reset() e2:Reset() e4:Reset() e:Reset()
			end
end
