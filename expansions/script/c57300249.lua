--无制限反转 创神
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddFusionProcFunRep(c,s.ffilter,4,false)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FLIP)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(s.flipop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(s.actlimit)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(s.setop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_FLIP)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(s.ffop)
	c:RegisterEffect(e6)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_FLIP)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function s.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionType(TYPE_FLIP) and c:IsLevelAbove(1) and (not sg or not sg:IsExists(Card.IsLevel,1,c,c:GetLevel()))
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsPosition(POS_ATTACK) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	end
end
function s.filter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsType(TYPE_FLIP)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false,POS_DEFENSE) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	tc:SetMaterial(nil)
	if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_DEFENSE)~=0 then
		tc:CompleteProcedure()
	end
end
function s.actlimit(e,c)
	return c:GetFlagEffect(id)==0
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.FromCards()
	for tc in aux.Next(eg) do
		if tc~=e:GetHandler() and tc:IsCanTurnSet() then
			g:AddCard(tc)
		end
		if g:GetCount()>0 then
			Duel.Hint(HINT_CARD,0,id)
			for dc in aux.Next(g) do
				Duel.ChangePosition(dc,POS_FACEDOWN_DEFENSE)
				dc:SetStatus(STATUS_SUMMON_TURN,false)
				dc:SetStatus(STATUS_SPSUMMON_TURN,false)
				dc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
			end
		end
	end
end
function s.ffop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.FromCards()
	for tc in aux.Next(eg) do
		if tc:IsPosition(POS_ATTACK) then
			g:AddCard(tc)
		end
		if g:GetCount()>0 then
			Duel.Hint(HINT_CARD,0,id)
			for dc in aux.Next(g) do
				Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
			end
		end
	end
end
--IsStatus(STATUS_SUMMON_TURN)STATUS_FLIP_SUMMON_TURN
--STATUS_SPSUMMON_TURN
--STATUS_FORM_CHANGED
--STATUS_FORBIDDEN
--EFFECT_CANNOT_PLACE_COUNTER