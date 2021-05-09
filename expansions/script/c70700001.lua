--湮灭骑兵宿敌 苍
function c70700001.initial_effect(c)
	 --
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_TO_DECK)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1) 
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAIN_NEGATED)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c70700001.spcon)
	e3:SetCost(c70700001.spcost)
	e3:SetTarget(c70700001.sptg)
	e3:SetOperation(c70700001.spop)
	c:RegisterEffect(e3)
	 if not c70700001.global_check then
		c70700001.table={}
		c70700001.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(c70700001.checkop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function c70700001.checkop(e,tp,eg,ep,ev,re,r,rp)
	c70700001.table={}
end
function c70700001.spcon(e,tp,eg,ep,ev,re,r,rp)
	for i,v in ipairs(c70700001.table) do
		if v==re:GetHandler():GetCode() then return false end
	end
   return re:IsHasCategory(CATEGORY_TODECK)
end
function c70700001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function c70700001.spfilter(c,e,tp)
	local sp=c:GetOwner()
	if Duel.GetMZoneCount(sp)<=0 then return false end
	if c:IsType(TYPE_MONSTER) then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,sp)
	elseif c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,0x11,1500,1500,2,RACE_WARRIOR,ATTRIBUTE_WATER,POS_FACEUP,sp)
	end
end
function c70700001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c70700001.spfilter(re:GetHandler(),e,tp) end
	table.insert(c70700001.table,re:GetHandler():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,re:GetHandler(),1,0,0)
end
function c70700001.spop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local sp=rc:GetOwner()
	if Duel.GetMZoneCount(sp)<=0 then return end
	if rc:IsType(TYPE_MONSTER) then
		Duel.SpecialSummon(rc,0,tp,sp,false,false,POS_FACEUP)
	elseif rc:IsType(TYPE_SPELL+TYPE_TRAP) then
		if Duel.SpecialSummonStep(rc,0,tp,sp,true,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(rc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_WARRIOR)
		rc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(ATTRIBUTE_WATER)
		rc:RegisterEffect(e3,true)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CHANGE_LEVEL)
		e6:SetValue(2)
		rc:RegisterEffect(e6,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(1500)
		rc:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(1500)
		rc:RegisterEffect(e5,true)
		end
		Duel.SpecialSummonComplete()
	end
end
