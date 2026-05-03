--英豪精神
-- 英豪精神
local s,id,o=GetID()
function s.initial_effect(c)
	-- Activate & Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	
	-- Equip Limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)

	--remove overlay replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920917,2))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c98920917.repcon)
	e3:SetOperation(c98920917.repop)
	c:RegisterEffect(e3)
end

-- 目标过滤
function s.filter(c,e,tp)
	return c:IsSetCard(0x6f) and c:IsType(TYPE_XYZ)
		and (s.spfilter1(c,e,tp) or s.spfilter2(c,e,tp))
end
function s.spfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.spfilter2(c,e,tp)
	return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetRank(),c:GetAttack())
end
function s.exfilter(c,e,tp,rk,atk)
	return c:IsSetCard(0x6f) and c:IsType(TYPE_XYZ) and (c:GetRank()>rk or c:GetAttack()>atk)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	
	local b1=s.spfilter1(tc,e,tp)
	local b2=s.spfilter2(tc,e,tp)
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1))
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	else
		return
	end

	if op==0 then
		-- 效果1：作为对象的怪兽特殊召唤，把这张卡装备
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.Equip(tp,c,tc)
		end
	else
		-- 效果2：比作为对象的怪兽阶级高的1只「英豪」超量怪兽从额外卡组特殊召唤...
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetRank(),tc:GetAttack())
		local sc=g:GetFirst()
		if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.Equip(tp,c,sc)
			Duel.Overlay(sc,tc) -- 作为对象的怪兽作为特殊召唤的怪兽的超量素材
		end
	end
end

function c98920917.repcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and re:GetHandler():GetOverlayCount()>=ev-1
		and e:GetHandler():GetEquipTarget()==re:GetHandler() and e:GetHandler():IsAbleToGraveAsCost() and ep==e:GetOwnerPlayer()
end
function c98920917.repop(e,tp,eg,ep,ev,re,r,rp)
	return Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
