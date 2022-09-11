--风暴星幽使
function c9910294.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c9910294.lcheck)
	c:EnableReviveLimit()
	--to extra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910294,0))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9910294.tecon)
	e1:SetCost(c9910294.cost)
	e1:SetTarget(c9910294.tetg)
	e1:SetOperation(c9910294.teop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910294,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9910294.descon)
	e2:SetCost(c9910294.cost)
	e2:SetTarget(c9910294.destg)
	e2:SetOperation(c9910294.desop)
	c:RegisterEffect(e2)
end
function c9910294.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_PENDULUM)
end
function c9910294.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(9910294)==0 end
	c:RegisterFlagEffect(9910294,RESET_CHAIN,0,1)
end
function c9910294.cfilter1(c,lg)
	return c:IsFaceup() and lg:IsContains(c) and c:IsSetCard(0x957)
end
function c9910294.tecon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return lg and eg:IsExists(c9910294.cfilter1,1,nil,lg)
end
function c9910294.tefilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c9910294.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910294.tefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9910294.fselect(g)
	return g:GetClassCount(Card.GetLocation)==g:GetCount()
end
function c9910294.teop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910294.tefilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910294,2))
	local sg=g:SelectSubGroup(tp,c9910294.fselect,false,1,2)
	if sg and sg:GetCount()>0 then
		Duel.SendtoExtraP(sg,nil,REASON_EFFECT)
	end
end
function c9910294.cfilter2(c,tp,zone)
	local seq=c:GetPreviousSequence()
	if c:IsPreviousControler(1-tp) then seq=seq+16 end
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousSetCard(0x957) and bit.extract(zone,seq)~=0
end
function c9910294.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910294.cfilter2,1,nil,tp,e:GetHandler():GetLinkedZone())
end
function c9910294.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9910294.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
