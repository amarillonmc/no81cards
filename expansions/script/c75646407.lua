--极北星辰 鹿乃
function c75646407.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c75646407.spfilter,3,false)	
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_HAND+LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c75646407.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_FIELD)
	--e2:SetCode(EFFECT_SPSUMMON_PROC)
	--e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	--e2:SetRange(LOCATION_EXTRA)
	--e2:SetCondition(c75646407.sprcon)
	--e2:SetOperation(c75646407.sprop)
	--c:RegisterEffect(e2)
	--lv change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,5646407)
	e3:SetCost(c75646407.cost)
	e3:SetTarget(c75646407.tg)
	e3:SetOperation(c75646407.op)
	c:RegisterEffect(e3)
	--tohand (self)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_ACTIVATE_COST)
	e5:SetTargetRange(1,0)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetOperation(aux.chainreg)
	c:RegisterEffect(e5)
	local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(75646407,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,75646407)
	e4:SetCondition(c75646407.con)
	e4:SetTarget(c75646407.tg1)
	e4:SetOperation(c75646407.op1)
	c:RegisterEffect(e4)
end
function c75646407.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c75646407.spfilter(c)
	return c:IsFusionSetCard(0x32c4) and c:IsCanBeFusionMaterial() and c:IsAbleToRemoveAsCost()
end
function c75646407.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c75646407.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,3,nil) and Duel.GetLocationCountFromEx(tp)>0
end
function c75646407.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c75646407.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,3,3,nil)
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c75646407.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return g:FilterCount(Card.IsAbleToGraveAsCost,nil)==1 end
	if g:GetFirst():IsSetCard(0x32c4) then e:SetValue(1) else e:SetValue(0) end
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(g,REASON_COST)
end
function c75646407.filter(c)
	return c:IsSetCard(0x32c4) and c:IsAbleToDeck()
end
function c75646407.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local t={}
	local i=1
	local p=1
	local lv=e:GetHandler():GetLevel()
	for i=4,9 do 
		if lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26082117,1))
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
	if e:GetValue()==1
		and Duel.IsExistingMatchingCard(c75646407.filter,tp,LOCATION_GRAVE,0,1,nil) then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end
end
function c75646407.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
	if e:GetValue()==1 and Duel.IsExistingMatchingCard(c75646407.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(75646407,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c75646407.filter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		end
	end
end
function c75646407.cfilter(c)
	return c:IsReason(REASON_COST)
end
function c75646407.con(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsHasType(0x7f0) and eg:IsExists(c75646407.cfilter,1,nil) and re:GetHandler():IsSetCard(0x32c4) and e:GetHandler():GetFlagEffect(1)>0
end
function c75646407.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c75646407.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end