--龙瀑还归
-- 通常陷阱卡：以相同属性的怪兽不在场上存在的自己或者对方墓地的1只怪兽为对象才能发动...
local s,id,o=GetID()
function s.initial_effect(c)
	-- 发动
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 检查场上是否存在相同属性的怪兽
function s.attfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end

-- 墓地怪兽合法性判定
function s.spfilter(c,e,tp)
	local att=c:GetAttribute()
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and not Duel.IsExistingMatchingCard(s.attfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,att)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		-- 结束阶段回到手卡
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		e1:SetCondition(s.thcon)
		e1:SetOperation(s.thop)
		Duel.RegisterEffect(e1,tp)
		-- 添加标识，如果怪兽离场或被里侧表示，标识会重置，防止错误弹手
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(id)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
