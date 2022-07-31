--键★断片 - 风子为愿望而游走 || K.E.Y Fragments - Fuuko, Hit and Run
--Scripted by: XGlitchy30

local s,id=GetID()
function s.initial_effect(c)
	c:SetCounterLimit(0x1460,1)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	local e1x=e1:Clone()
	e1x:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1x)
	local e1y=e1:Clone()
	e1y:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e1y)
	--equip effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(s.eqcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e2y=e2:Clone()
	e2y:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2y:SetValue(1)
	c:RegisterEffect(e2y)
	--light orb
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetCode(EVENT_CUSTOM+id)
	e3:SetCondition(s.ctcon)
	e3:SetTarget(s.cttg)
	e3:SetOperation(s.ctop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_EQUIP)
		e1:SetOperation(s.regop)
		Duel.RegisterEffect(e1,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for p=tp,1-tp,1-2*tp do
		local g=eg:Filter(aux.FilterEqualFunction(Card.GetReasonPlayer,p),nil)
		if #g>0 then
			local ct=Duel.GetFlagEffect(p,id)>0 and Duel.GetFlagEffectLabel(p,id) or 0
			if ct==0 then
				Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1,0)
			end
			Duel.SetFlagEffectLabel(p,id,Duel.GetFlagEffectLabel(p,id)+#g)
			if ct<3 and Duel.GetFlagEffectLabel(p,id)>=3 then
				Duel.RaiseEvent(eg,EVENT_CUSTOM+id,re,r,rp,p,ev)
			end
		end
	end
end

function s.eqfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x460) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_SPELLCASTER+RACE_WARRIOR)
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToChain(0) or Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(s.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end

function s.eqcon(e)
	return e:GetHandler():GetEquipTarget():IsSetCard(0x460)
end

function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,c,1,0,0x1460)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:IsCanAddCounter(0x1460,1,false,c:GetLocation()) then
		c:AddCounter(0x1460,1)
	end
end