--余码语者·扩展
function c98920449.initial_effect(c)
	aux.EnableChangeCode(c,40669071)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_CYBERSE),2)
	--lock
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920449,0))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98920449)
	e1:SetCondition(c98920449.tecon)
	e1:SetTarget(c98920449.tetg)
	e1:SetOperation(c98920449.teop)
	c:RegisterEffect(e1)
	--atk up/indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c98920449.tgtg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c98920449.tecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c98920449.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
end
function c98920449.teop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	if e:GetLabel()==0 then
		e1:SetDescription(aux.Stringid(98920449,2))
		e1:SetValue(c98920449.aclimit1)
	elseif e:GetLabel()==1 then
		e1:SetDescription(aux.Stringid(98920449,3))
		e1:SetValue(c98920449.aclimit2)
	else
		e1:SetDescription(aux.Stringid(98920449,4))
		e1:SetValue(c98920449.aclimit3)
	end
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98920449.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c98920449.aclimit2(e,re,tp)
	return re:IsActiveType(TYPE_SPELL)
end
function c98920449.aclimit3(e,re,tp)
	return re:IsActiveType(TYPE_TRAP)
end
function c98920449.lzfilter(c)
	return c:GetSequence()>4
end
function c98920449.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c98920449.lzfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return ct>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)
			+Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>ct end
	local dis=Duel.SelectDisableField(tp,ct,LOCATION_MZONE,LOCATION_MZONE,0xe000e0)
	e:SetLabel(dis)
	Duel.Hint(HINT_ZONE,tp,dis)
end
function c98920449.lzop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetLabel()
	if tp==1 then
		zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(zone)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function c98920449.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end