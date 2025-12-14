--幻叙冥渡人 奈克罗寻
local s,id,o=GetID()
function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.eqcon)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1) 
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(s.atkcon)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
	
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_CUSTOM+id)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.syntg)
	e4:SetOperation(s.synop)
	c:RegisterEffect(e4)
end

--Helpers
function s.eqfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.eqfilter,1,e:GetHandler(),tp)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(s.eqfilter,e:GetHandler(),tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,#g,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(s.eqfilter,c,tp)
	if #g==0 or c:IsFacedown() or not c:IsRelateToChain() then return end
	local tc=g:GetFirst()
	if g:GetCount()>1 then tc=g:Select(tp,1,1,nil) end
	if tc and Duel.Equip(tp,tc,c,true) then
		--Treat as Equip Spell
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		tc:RegisterEffect(e1)
		--Level Up (Bound to equip card)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetValue(tc:GetOriginalLevel())
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		--Flag for Battle Debuff calculation
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		if c:GetLevel()>=13 then
			Duel.RaiseSingleEvent(c,EVENT_CUSTOM+id,e,0,tp,tp,0)
		end
	end
end
function s.eqlimit(e,c)
	return c==e:GetOwner()
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return c:GetBattleTarget()
end
function s.atkfilter(c,att)
	return c:GetFlagEffect(id)>0 and c:GetOriginalAttribute()~=att
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsFaceup() and bc:IsFaceup() then
		local att=bc:GetAttribute()
		local g=c:GetEquipGroup()
		local ct=g:FilterCount(s.atkfilter,nil,att)*500
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(s.atkcon)
		e2:SetValue(-ct)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		bc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		bc:RegisterEffect(e3)
	end
end
function s.synfilter(c,e,tp)
	return c:IsCode(65133197) and c:IsSynchroSummonable(nil)
end
function s.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(tp,id,0,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.synop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoGrave(c,REASON_EFFECT)==0 or not c:IsLocation(LOCATION_GRAVE) then return end
	
	local sc=Duel.GetFirstMatchingCard(s.synfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if not sc then return end
	
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsCanBeSynchroMaterial),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,sc)
	
	Duel.SynchroSummon(tp,sc,nil,mg)
end
