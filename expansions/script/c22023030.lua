--人理保障？ 咕哒夫
function c22023030.initial_effect(c)
	aux.EnableChangeCode(c,22020000,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK)
	--synchro custom
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(c22023030.syntg)
	e1:SetValue(1)
	e1:SetOperation(c22023030.synop)
	c:RegisterEffect(e1)
	--hand synchro
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetCode(EFFECT_HAND_SYNCHRO)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22023030,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c22023030.cost)
	e3:SetTarget(c22023030.target)
	e3:SetOperation(c22023030.operation)
	c:RegisterEffect(e3)
	--Ereshkigal
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22023030,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1)
	e4:SetCondition(c22023030.erescon)
	e4:SetCost(c22023030.cost1)
	e4:SetTarget(c22023030.target)
	e4:SetOperation(c22023030.operation)
	c:RegisterEffect(e4)
end
c22023030.effect_with_master=true
function c22023030.erescon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22023030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22023030.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22023030.filter(c)
	return c:IsSetCard(0xff1) and not c:IsSetCard(0x3ff1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c22023030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023030.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22023030.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22023030.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22023030.synfilter(c,syncard,tuner,f)
	return c:IsFaceupEx() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
end
function c22023030.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
	g:AddCard(c)
	local ct=g:GetCount()
	local res=c22023030.syngoal(g,tp,lv,syncard,minc,ct)
		or (ct<maxc and mg:IsExists(c22023030.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
	g:RemoveCard(c)
	return res
end
function c22023030.syngoal(g,tp,lv,syncard,minc,ct)
	return ct>=minc
		and g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
		and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
		and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)<=1
		and aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL)
end
function c22023030.syntg(e,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()
	if lv<=c:GetLevel() then return false end
	local g=Group.FromCards(c)
	local mg=Duel.GetSynchroMaterial(tp):Filter(c22023030.synfilter,c,syncard,c,f)
	local exg=Duel.GetMatchingGroup(c22023030.synfilter,tp,LOCATION_HAND,0,c,syncard,c,f)
	mg:Merge(exg)
	return mg:IsExists(c22023030.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function c22023030.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	local g=Group.FromCards(c)
	local mg=Duel.GetSynchroMaterial(tp):Filter(c22023030.synfilter,c,syncard,c,f)
	local exg=Duel.GetMatchingGroup(c22023030.synfilter,tp,LOCATION_HAND,0,c,syncard,c,f)
	mg:Merge(exg)
	for i=1,maxc do
		local cg=mg:Filter(c22023030.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if c22023030.syngoal(g,tp,lv,syncard,minc,i) then
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=cg:Select(tp,minct,1,nil)
		if sg:GetCount()==0 then break end
		g:Merge(sg)
	end
	Duel.SetSynchroMaterial(g)
end