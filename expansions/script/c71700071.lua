-- 贯极之蜂姬
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCost(s.tgcost)
	e3:SetTarget(s.tgtg2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(s.atktg)
	c:RegisterEffect(e4)
end
function s.spfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) 
end
function s.spcon(e,c)
	if c==nil then return true end
	if c:IsLocation(LOCATION_GRAVE) then
		return Duel.GetMatchingGroupCount(s.spfilter,c:GetControler(),LOCATION_MZONE,0,nil)>0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	elseif c:IsLocation(LOCATION_HAND) then 
		return (Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0 or Duel.GetMatchingGroupCount(s.spfilter,c:GetControler(),LOCATION_MZONE,0,nil)>0) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	end
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.tgfilter(c,atk,ec)
	return c:IsAbleToGrave() and c:GetDefense()~=atk and c~=ec and not (c:IsCode(id) or c:IsType(TYPE_LINK))
end
function s.costfilter(c,e,ec,tp)
	return c:IsRace(RACE_INSECT) and Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c,ec)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.tgfilter(chkc,atk) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,atk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,atk)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function s.tgtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.tgfilter(chkc,c:GetAttack()) end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.CheckReleaseGroup(tp,s.costfilter,1,nil,c,tp)
		else
			return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local sg=Duel.SelectReleaseGroup(tp,s.costfilter,1,1,nil,c,tp)
		Duel.Release(sg,REASON_COST)
		Duel.SetChainLimit(s.chainlm)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local dmg=0
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:GetDefense()>c:GetAttack() then
		dmg=tc:GetDefense()-c:GetAttack()
	elseif tc:GetDefense()<c:GetAttack() then
		dmg=c:GetAttack()-tc:GetDefense()
	end
	if tc:IsRelateToChain(e) then
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and c:IsRelateToChain(e) then
			Duel.Damage(1-tp,dmg,REASON_EFFECT)
		end
	end
end
function s.chainlm(re,rp,tp)
	return tp==rp 
end
function s.atktg(e,c)
	return c:IsRace(RACE_INSECT)
end