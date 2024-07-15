--XNo.39 银河眼光波龙皇
local m=11561063
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),8,3,c11561063.ovfilter,aux.Stringid(11561063,1),3,c11561063.xyzop)
	--adjust
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c11561063.adjustop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c11561063.sptg)
	e2:SetOperation(c11561063.spop)
	c:RegisterEffect(e2)
	
	if not c11561063.global_check then
		c11561063.global_check=true
		c11561063.codetable={}

		_IsCode=Card.IsCode
		Card.IsSetCard=function (c,...)
			if _IsCode(c,...) then return true end
			if #c11561063.codetable>0 and c:IsCode(11561063) then
				for i,v in ipairs(c11561063.codetable) do
					if _IsCode(v,...) then return true end
				end
			end
			return false
		end
		_IsCode=Card.IsLinkCode
		Card.IsSetCard=function (c,...)
			if _IsCode(c,...) then return true end
			if #c11561063.codetable>0 and c:IsCode(11561063) then
				for i,v in ipairs(c11561063.codetable) do
					if _IsCode(v,...) then return true end
				end
			end
			return false
		end
		_IsCode=Card.IsFusionCode
		Card.IsSetCard=function (c,...)
			if _IsCode(c,...) then return true end
			if #c11561063.codetable>0 and c:IsCode(11561063) then
				for i,v in ipairs(c11561063.codetable) do
					if _IsCode(v,...) then return true end
				end
			end
			return false
		end
		_IsSetCard=Card.IsSetCard
		Card.IsSetCard=function (c,...)
			if _IsSetCard(c,...) then return true end
			if #c11561063.codetable>0 and c:IsCode(11561063) then
				for i,v in ipairs(c11561063.codetable) do
					if _IsSetCard(v,...) then return true end
				end
			end
			return false
		end
		_IsLinkSetCard=Card.IsLinkSetCard
		Card.IsLinkSetCard=function (c,...)
			if _IsLinkSetCard(c,...) then return true end
			if #c11561063.codetable>0 and c:IsCode(11561063) then
				for i,v in ipairs(c11561063.codetable) do
					if _IsLinkSetCard(v,...) then return true end
				end
			end
			return false
		end
		_IsFusionSetCard=Card.IsFusionSetCard
		Card.IsFusionSetCard=function (c,...)
			if _IsFusionSetCard(c,...) then return true end
			if #c11561063.codetable>0 and c:IsCode(11561063) then
				for i,v in ipairs(c11561063.codetable) do
					if _IsFusionSetCard(v,...) then return true end
				end
			end
			return false
		end
		_IsPreviousSetCard=Card.IsPreviousSetCard
		Card.IsPreviousSetCard=function (c,...)
			if _IsPreviousSetCard(c,...) then return true end
			if #c11561063.codetable>0 and c:IsCode(11561063) then
				for i,v in ipairs(c11561063.codetable) do
					if _IsPreviousSetCard(v,...) then return true end
				end
			end
			return false
		end
	end
end
aux.xyz_number[11561063]=39
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end


function c11561063.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function c11561063.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayGroup():IsExists(c11561063.spfilter,1,nil,e,tp) and Duel.GetMZoneCount(1-tp)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_OVERLAY)
end
function c11561063.gcheck(g)
	return g:GetClassCount(Card.GetOverlayTarget)==#g
end
function c11561063.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local g=Duel.GetOverlayGroup(tp,1,0):Filter(c11561063.spfilter,nil,e,tp)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c11561063.gcheck,false,1,ft)
	if sg:GetCount()>0 and Duel.SpecialSummon(sg,0,tp,1-tp,false,false,POS_FACEUP)~=0 then

	end
end

--

function c11561063.ovfilter(c)
	return c:IsFaceup() and c:IsCode(18963306)
end
function c11561063.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,11561063)==0 end
	Duel.RegisterFlagEffect(tp,11561063,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c11561063.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	c11561063.codetable={}
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	local g=c:GetOverlayGroup()
	local tc=g:GetFirst()
	while tc do
		table.insert(c11561063.codetable,tc)
		tc=g:GetNext()
	end
end







