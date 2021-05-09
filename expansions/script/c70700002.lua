--湮灭骑兵的宿敌 掠夺
function c70700002.initial_effect(c)
	 --cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(e2)
	 --special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAIN_NEGATED)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c70700002.spcon)
	e3:SetTarget(c70700002.sptg)
	e3:SetOperation(c70700002.spop)
	c:RegisterEffect(e3)
	 if not c70700002.global_check then
		c70700002.table={}
		c70700002.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(c70700002.checkop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function c70700002.checkop(e,tp,eg,ep,ev,re,r,rp)
	c70700002.table={}
end
function c70700002.spcon(e,tp,eg,ep,ev,re,r,rp)
	for i,v in ipairs(c70700002.table) do
		if v==re:GetHandler():GetCode() then return false end
	end
   return re:IsHasCategory(CATEGORY_REMOVE)
end
function c70700002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and (re:GetHandler():IsFaceup() or re:GetHandler():IsOnField()) end
	table.insert(c70700002.table,re:GetHandler():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c70700002.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 and (re:GetHandler():IsFaceup() or re:GetHandler():IsOnField()) then
		if not Duel.Equip(tp,re:GetHandler(),e:GetHandler(),false) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c70700002.eqlimit)
		re:GetHandler():RegisterEffect(e1)
	end
end
function c70700002.eqlimit(e,c)
	return e:GetOwner()==c
end