--欢愉的乐园五号线
local m=43990110
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	--MoveToField
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43990110,1))
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,43990110)
	e3:SetCondition(c43990110.mtcon)
	e3:SetTarget(c43990110.mttg)
	e3:SetOperation(c43990110.mtop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,43991110)
	e4:SetOperation(c43990110.xxgop)
	c:RegisterEffect(e4)
	
end
function c43990110.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_ILLUSION)
end
function c43990110.tffilter(c,tp)
	return c:IsSetCard(0x5510) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c43990110.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c43990110.tffilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
end
function c43990110.gcheck(g,e,tp)
	return (g:IsExists(Card.IsLocation,2,nil,LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1) or g:GetCount()<2 
end
function c43990110.mtop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local sg=Duel.GetMatchingGroup(c43990110.tffilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	if ct<1 or #sg<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tg=sg:SelectSubGroup(tp,c43990110.gcheck,false,1,2,e,tp)
	local tc=tg:GetFirst()
	while tc do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		tc=tg:GetNext()
	end
end
function c43990110.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg)
end
function c43990110.xyzfilter2(c)
	return c:IsCanBeXyzMaterial(nil)
end
function c43990110.xxgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local off=3
	local ops={}
	local opval={}
	local mg=Duel.GetMatchingGroup(c43990110.xyzfilter2,tp,LOCATION_MZONE,0,nil)
	ops[1]=aux.Stringid(43990110,4)
	opval[0]=1
	ops[2]=aux.Stringid(43990110,5)
	opval[1]=2
	if not c:IsForbidden() and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		ops[off]=aux.Stringid(43990110,6)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c43990110.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) then
		ops[off]=aux.Stringid(43990110,7)
		opval[off-1]=4
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Damage(1-tp,500,REASON_EFFECT)
	elseif opval[op]==2 then
		Duel.Recover(tp,500,REASON_EFFECT)
	elseif opval[op]==3 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	elseif opval[op]==4 then
		local g=Duel.GetMatchingGroup(c43990110.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),mg)
	end
end






