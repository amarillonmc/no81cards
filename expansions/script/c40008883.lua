--空牙团的卡通 福尔戈
function c40008883.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x62),3,3,c40008883.lcheck)
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetCondition(c40008883.dircon1)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,40008883)
	e2:SetCondition(c40008883.spcon)
	e2:SetTarget(c40008883.sptg)
	e2:SetOperation(c40008883.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c40008883.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,40008884)
	e4:SetCondition(c40008883.drcon)
	e4:SetTarget(c40008883.drtg)
	e4:SetOperation(c40008883.drop)
	c:RegisterEffect(e4)
	--cannot attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCondition(c40008883.regcon)
	e6:SetOperation(c40008883.atklimit)
	c:RegisterEffect(e6)
	--direct attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetCondition(c40008883.dircon)
	c:RegisterEffect(e5)
end
function c40008883.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function c40008883.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c40008883.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c40008883.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c40008883.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c40008883.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c40008883.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c40008883.dircon1(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(c40008883.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)		
end
function c40008883.lcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==g:GetCount()
end
function c40008883.valcheck(e,c)
	local g=c:GetMaterial()
	local val=0
	for tc in aux.Next(g) do
		val=bit.bor(val,tc:GetRace())
	end
	e:GetLabelObject():SetLabel(val)
end
function c40008883.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetMaterialCount()==3
end
function c40008883.spfilter(c,e,tp,rc)
	return c:IsSetCard(0x62) and not c:IsRace(rc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c40008883.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40008883.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c40008883.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40008883.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c40008883.drcfilter(c,tp)
	return  c:GetPreviousControler()~=tp 
end
function c40008883.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c40008883.drcfilter,1,nil,tp)
end
function c40008883.drfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x62)
end
function c40008883.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c40008883.drfilter,tp,LOCATION_MZONE,0,nil)
	local ct=1
	if g:GetClassCount(Card.GetCode)>=3 then ct=3 end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c40008883.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c40008883.drfilter,tp,LOCATION_MZONE,0,nil)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Draw(p,1,REASON_EFFECT)>0 and g:GetClassCount(Card.GetCode)>=3 then
		Duel.BreakEffect()
		Duel.Draw(p,2,REASON_EFFECT)
	end
end

