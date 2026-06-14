--冥导魔神帝 暗黑吕克莫诺斯
local s,id=GetID()
s.named_with_InfernalLord=1
function s.InfernalLord(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_InfernalLord
end
function s.Grandwalker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Grandwalker
end
function s.initial_effect(c)
	c:EnableReviveLimit()
		aux.AddCodeList(c,40020547)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.ritg)
	e1:SetOperation(s.riop)
	c:RegisterEffect(e1)
	
	local e2a=Effect.CreateEffect(c)
	e2a:SetDescription(aux.Stringid(id,1))
	e2a:SetCategory(CATEGORY_TOGRAVE)
	e2a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2a:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2a:SetProperty(EFFECT_FLAG_DELAY)
	e2a:SetCondition(s.tgcon_a)
	e2a:SetTarget(s.tgtg)
	e2a:SetOperation(s.tgop)
	c:RegisterEffect(e2a)

	local e2b=Effect.CreateEffect(c)
	e2b:SetDescription(aux.Stringid(id,1))
	e2b:SetCategory(CATEGORY_TOGRAVE)
	e2b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2b:SetProperty(EFFECT_FLAG_DELAY)
	e2b:SetRange(LOCATION_MZONE)
	e2b:SetCondition(s.tgcon_b)
	e2b:SetTarget(s.tgtg)
	e2b:SetOperation(s.tgop)
	c:RegisterEffect(e2b)

	local e2c=Effect.CreateEffect(c)
	e2c:SetDescription(aux.Stringid(id,1))
	e2c:SetCategory(CATEGORY_TOGRAVE)
	e2c:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2c:SetCode(EVENT_TO_GRAVE)
	e2c:SetProperty(EFFECT_FLAG_DELAY)
	e2c:SetCondition(s.tgcon_c)
	e2c:SetTarget(s.tgtg)
	e2c:SetOperation(s.tgop)
	c:RegisterEffect(e2c)
end

s.HADES_CODE=40020547

function s.has_hades(tp)
	local pz0=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local pz1=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if (pz0 and pz0:IsCode(s.HADES_CODE)) or (pz1 and pz1:IsCode(s.HADES_CODE)) then
		return true
	end
	return Duel.IsExistingMatchingCard(function(c) return c:IsCode(s.HADES_CODE) and c:IsFaceup() end, tp, LOCATION_EXTRA, 0, 1, nil)
end

function s.place_filter(c, has_hades_flag)
	if c:IsForbidden() or not c:IsType(TYPE_PENDULUM) then return false end
	if c:IsLocation(LOCATION_EXTRA) and c:IsFacedown() then return false end
	if not has_hades_flag then
		return c:IsCode(s.HADES_CODE)
	else
		return s.Grandwalker(c)
	end
end

function s.ritg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		local empty=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		local sp=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		if not (empty and sp) then return false end
		local has_hades = s.has_hades(tp)
		return Duel.IsExistingMatchingCard(s.place_filter, tp, LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA, 0, 1, nil, has_hades)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function s.riop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	local has_hades = s.has_hades(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp, s.place_filter, tp, LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA, 0, 1, 1, nil, has_hades)
	if #g>0 then
		local tc=g:GetFirst()
		if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
			if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				if Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
					c:CompleteProcedure()
				end
			end
		end
	end
end

function s.tgcon_a(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) then return false end
	return Duel.GetFlagEffect(tp,id+100)==0
end

function s.rit_filter(c,tp,ec)
	return c:IsSummonType(SUMMON_TYPE_RITUAL) and c:IsControler(tp) and c~=ec
end
function s.tgcon_b(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id+200)>0 then return false end
	return eg:IsExists(s.rit_filter,1,nil,tp,e:GetHandler())
end

function s.tgcon_c(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id+300)==0
end

function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
	local code = e:GetCode()
	local typ = e:GetType()
	if code == EVENT_SPSUMMON_SUCCESS then
		if (typ & EFFECT_TYPE_SINGLE) ~= 0 then
			Duel.RegisterFlagEffect(tp,id+100,RESET_PHASE+PHASE_END,0,1)
			e:SetLabel(100)
		else
			Duel.RegisterFlagEffect(tp,id+200,RESET_PHASE+PHASE_END,0,1)
			e:SetLabel(200)
		end
	elseif code == EVENT_TO_GRAVE then
		Duel.RegisterFlagEffect(tp,id+300,RESET_PHASE+PHASE_END,0,1)
		e:SetLabel(300)
	end
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end