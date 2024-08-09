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
	e2:SetDescription(aux.Stringid(11561063,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c11561063.sptg)
	e2:SetOperation(c11561063.spop)
	c:RegisterEffect(e2)
	--CANNOT be tg
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11561063,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c11561063.cost)
	e3:SetOperation(c11561063.operation)
	c:RegisterEffect(e3)
	
	if not c11561063.global_check then
		c11561063.global_check=true
		c11561063.codetable={}
		c11561063.setcardtable={}

		_IsCode=Card.IsCode
		Card.IsCode=function (c,...)
			if _IsCode(c,...) then return true end
			if #c11561063.codetable>0 and c:GetOriginalCode()==11561063 then
				for i,v in ipairs(c11561063.codetable) do
					if _IsCode(v,...) then return true end
				end
			end
			return false
		end
		_IsCode=Card.IsLinkCode
		Card.IsLinkCode=function (c,...)
			if _IsCode(c,...) then return true end
			if #c11561063.codetable>0 and c:GetOriginalCode()==11561063 then
				for i,v in ipairs(c11561063.codetable) do
					if _IsCode(v,...) then return true end
				end
			end
			return false
		end
		_IsCode=Card.IsFusionCode
		Card.IsFusionCode=function (c,...)
			if _IsCode(c,...) then return true end
			if #c11561063.codetable>0 and c:GetOriginalCode()==11561063 then
				for i,v in ipairs(c11561063.codetable) do
					if _IsCode(v,...) then return true end
				end
			end
			return false
		end


		_IsSetCard=Card.IsSetCard
		Card.IsSetCard=function (c,...)
			if _IsSetCard(c,...) then return true end
			if #c11561063.setcardtable>0 and c:GetOriginalCode()==11561063 then
				for i,v in ipairs(c11561063.setcardtable) do
					if _IsSetCard(v,...) then return true end
				end
			end
			return false
		end
		_IsLinkSetCard=Card.IsLinkSetCard
		Card.IsLinkSetCard=function (c,...)
			if _IsLinkSetCard(c,...) then return true end
			if #c11561063.setcardtable>0 and c:GetOriginalCode()==11561063 then
				for i,v in ipairs(c11561063.setcardtable) do
					if _IsLinkSetCard(v,...) then return true end
				end
			end
			return false
		end
		_IsFusionSetCard=Card.IsFusionSetCard
		Card.IsFusionSetCard=function (c,...)
			if _IsFusionSetCard(c,...) then return true end
			if #c11561063.setcardtable>0 and c:GetOriginalCode()==11561063 then
				for i,v in ipairs(c11561063.setcardtable) do
					if _IsFusionSetCard(v,...) then return true end
				end
			end
			return false
		end
		_IsPreviousSetCard=Card.IsPreviousSetCard
		Card.IsPreviousSetCard=function (c,...)
			if _IsPreviousSetCard(c,...) then return true end
			if #c11561063.setcardtable>0 and c:GetOriginalCode()==11561063 then
				for i,v in ipairs(c11561063.setcardtable) do
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
	if chk==0 then return Duel.GetOverlayGroup(tp,1,0):IsExists(c11561063.spfilter,1,nil,e,tp) and Duel.GetMZoneCount(1-tp)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_OVERLAY)
end
function c11561063.gcheckfilter(g)
	return g:GetOverlayTarget():GetSequence()
end
function c11561063.gcheck(g)
	return g:GetClassCount(c11561063.gcheckfilter)==#g
end
function c11561063.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local g=Duel.GetOverlayGroup(tp,1,0):Filter(c11561063.spfilter,nil,e,tp)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c11561063.gcheck,false,1,ft)
	if sg:GetCount()>0 and Duel.SpecialSummon(sg,0,tp,1-tp,false,false,POS_FACEUP)~=0 then
		local tc=Duel.GetOperatedGroup():GetCount()
		if tc>0 and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,tc,nil) and c:IsRelateToEffect(e) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			Duel.BreakEffect()
			local xg=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,tc,tc,nil)
			local xtc=xg:GetFirst()
			while xtc do
				local og=xtc:GetOverlayGroup()
				if og:GetCount()>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				Duel.Overlay(c,Group.FromCards(xtc))
				xtc=xg:GetNext()
			end
		end
	end
end
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
	c11561063.setcardtable={}
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	local g=c:GetOverlayGroup()
	local tc=g:GetFirst()
	while tc do
		table.insert(c11561063.codetable,tc)
		table.insert(c11561063.setcardtable,tc)
		tc=g:GetNext()
	end
end
function c11561063.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c11561063.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c11561063.filter(c)
	return (c:IsRankBelow(9) or c:IsLevelBelow(9)) and c:IsAttribute(ATTRIBUTE_LIGHT) and (c:IsAbleToExtra() or c:IsAbleToHand())
end
function c11561063.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11561063.filter1,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	if Duel.IsExistingMatchingCard(c11561063.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11561063,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c11561063.filter,tp,LOCATION_GRAVE,0,1,1,nil)
		if #g==0 then return end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end



