--哥伦比亚·特种干员-罗宾
function c79029368.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2,c79029368.ovfilter,aux.Stringid(79029368,4))
	c:EnableReviveLimit()   
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,79029368)
	e1:SetCost(c79029368.zcost)
	e1:SetTarget(c79029368.ztg)
	e1:SetOperation(c79029368.zop)
	c:RegisterEffect(e1)	 
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,19029368)
	e2:SetCondition(c79029368.xyzcon)
	e2:SetTarget(c79029368.xyztg)
	e2:SetOperation(c79029368.xyzop)
	c:RegisterEffect(e2)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79029368,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,09029368)
	e4:SetCondition(c79029368.thcon)
	e4:SetTarget(c79029368.thtg)
	e4:SetOperation(c79029368.thop)
	c:RegisterEffect(e4)
end
function c79029368.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa904)
end
function c79029368.zcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029368.ztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,0)>0 end
	local dis=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	local seq=math.log(bit.rshift(dis,16),2)
	e:SetLabel(seq)
	Duel.Hint(HINT_ZONE,tp,dis)
end
function c79029368.zop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("我准备好了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029368,0))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029368.spcon)
	e1:SetOperation(c79029368.spop)
	e1:SetLabel(e:GetLabel())
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
end
function c79029368.fil(c,seq)
	return c:GetSequence()==seq and c:IsAbleToHand()
end
function c79029368.spcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetLabel()
	if not eg:Filter(Card.IsControler,nil,1-tp):IsExists(c79029368.fil,1,nil,seq) then return end 
	local tc=eg:GetFirst()
	return eg:Filter(Card.IsControler,nil,1-tp):IsExists(c79029368.fil,1,nil,seq) 
end
function c79029368.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,79029368)==0 then
	Debug.Message("你们在看哪里呢。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029368,1))
	Duel.Hint(HINT_CARD,0,79029368)
	local seq=e:GetLabel()
	local xg=eg:Filter(Card.IsControler,nil,1-tp):Filter(c79029368.fil,nil,seq)
	local tc=xg:GetFirst()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,79029368,0,0,0)
	else
	Duel.ResetFlagEffect(tp,79029368)
	end
	e:Reset()
end  
function c79029368.cfilter1(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c79029368.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79029368.cfilter1,1,nil,1-tp) and Duel.GetCurrentPhase()~=PHASE_DRAW 
end
function c79029368.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c79029368.xyzop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("我也是有脾气的！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029368,2))
	local xg=eg:Filter(c79029368.cfilter1,nil,1-tp)
	local c=e:GetHandler()
	Duel.Overlay(c,xg)
end
function c79029368.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c79029368.ssfil(c,e)
	return c:IsSSetable(false) and (c:IsSetCard(0xb90d) or c:IsSetCard(0xc90e)) and c:IsType(TYPE_TRAP)
end
function c79029368.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c79029368.ssfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e)>=1 end
end
function c79029368.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("我的武器可不止匕首！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029368,3))
	local tc=Duel.SelectMatchingCard(tp,c79029368.ssfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e):GetFirst()
	Duel.SSet(tp,tc)
end




