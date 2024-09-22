--泽塔·兵器
function c98921055.initial_effect(c)
	aux.AddCodeList(c,64382839)
	--link summon
	aux.AddLinkProcedure(c,nil,3,3,c98921055.lcheck)
	c:EnableReviveLimit()	
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c98921055.val)
	c:RegisterEffect(e4)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD+LOCATION_GRAVE,0)
	e2:SetTarget(c98921055.imval)
	e2:SetValue(c98921055.tgval)
	c:RegisterEffect(e2)
	--remove monster
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98921055,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(c98921055.remtg1)
	e3:SetOperation(c98921055.remop1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c98921055.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_TOKEN)
end
function c98921055.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsCode,c:GetControler(),LOCATION_GRAVE,0,nil,64382839)*1000
end
function c98921055.imval(e,c)
	return c~=e:GetHandler()
end
function c98921055.tgval(e,re,rp)
	return rp==1-e:GetHandlerPlayer()
end
function c98921055.filter(c,e,tp)
	return c:IsSummonPlayer(1-tp) and c:IsLocation(LOCATION_MZONE) and c:IsAbleToRemove()
		and (not e or c:IsRelateToEffect(e))
end
function c98921055.remtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c98921055.filter,1,nil,nil,tp) end
	local g=eg:Filter(c98921055.filter,nil,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200)
end
function c98921055.remop1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c98921055.filter,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end