--联合作战-部署·定点接送
function c79029322.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029322)
	e1:SetTarget(c79029322.ztg)
	e1:SetOperation(c79029322.zop)
	c:RegisterEffect(e1) 
	--remove overlay replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029322,1))
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,09029322)
	e1:SetCondition(c79029322.rcon)
	e1:SetOperation(c79029322.rop)
	c:RegisterEffect(e1)
end
function c79029322.ztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,0)>0 end
	local dis=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local seq=math.log(bit.rshift(dis,0),2)
	e:SetLabel(seq)
	Duel.Hint(HINT_ZONE,tp,dis)
end
function c79029322.zop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029322.spcon)
	e1:SetOperation(c79029322.spop)
	e1:SetLabel(e:GetLabel())
	Duel.RegisterEffect(e1,tp)
end
function c79029322.xxfil(c,seq)
	local tc=Duel.GetMatchingGroup(c79029322.fil,tp,LOCATION_MZONE,0,nil,seq):GetFirst()
	return c:GetLinkedGroup():IsContains(tc) and c:IsSetCard(0xa900)
end
function c79029322.fil(c,seq)
	return c:IsSetCard(0xa900) and c:GetSequence()==seq
end
function c79029322.spcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetLabel()
	return eg:IsExists(c79029322.fil,1,nil,seq)
end
function c79029322.spop(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetLabel()
	Duel.Hint(HINT_CARD,0,79029322)
	local xg=eg:Filter(c79029322.fil,nil,seq)
	local atk=xg:GetSum(Card.GetAttack)
	Duel.Recover(tp,atk,REASON_EFFECT,true)
	Duel.Damage(1-tp,atk,REASON_EFFECT,true)
	Duel.RDComplete()
	if Duel.IsExistingMatchingCard(c79029322.xxfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,seq) and Duel.IsPlayerCanDraw(tp,2) and Duel.SelectYesNo(tp,aux.Stringid(79029322,0)) then
	Duel.Draw(tp,2,REASON_EFFECT)
	end
	e:Reset()
end
function c79029322.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsSetCard(0xa900) and ep==e:GetOwnerPlayer() and e:GetHandler():IsAbleToRemove() and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
end
function c79029322.rop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
	local g=Group.FromCards(tc,e:GetHandler())
	return Duel.Remove(g,POS_FACEUP,REASON_COST)
end













