--幻爆术的灵脉
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,80280737)
	--场上的这张卡为素材作同调召唤的场合，手卡1只怪兽也能作为同调素材
	--手卡同调：EFFECT_SYNCHRO_MATERIAL_CUSTOM + EFFECT_HAND_SYNCHRO（参照たつのこ）
	local e0a=Effect.CreateEffect(c)
	e0a:SetType(EFFECT_TYPE_SINGLE)
	e0a:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e0a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0a:SetCondition(s.hscon)
	e0a:SetTarget(s.syntg)
	e0a:SetValue(1)
	e0a:SetOperation(s.synop)
	c:RegisterEffect(e0a)
	local e0b=Effect.CreateEffect(c)
	e0b:SetType(EFFECT_TYPE_SINGLE)
	e0b:SetCode(EFFECT_HAND_SYNCHRO)
	e0b:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0b:SetCondition(s.hscon)
	e0b:SetTargetRange(0,1)
	c:RegisterEffect(e0b)

	--①：从手卡·卡组把最多4只卡名不同的「/爆裂体」怪兽除外才能发动。
	--这张卡特殊召唤，这张卡的等级下降除外数量的数值。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	--②：自己·对方的主要阶段，这张卡在墓地存在的场合才能发动。
	--从自己的手卡·场上把1张有「爆裂模式」的卡名记述的卡给对方观看并回到卡组。
	--那之后，这张卡加入手卡，自己抽1张。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

----------------------------------------------------------------
-- 手卡同调（参照たつのこ模式）
----------------------------------------------------------------
function s.hscon(e)
	return e:GetHandler():IsFaceup()
end
function s.synfilter(c,syncard,tuner,f)
	return c:IsFaceupEx() and c:IsCanBeSynchroMaterial(syncard,tuner)
		and (f==nil or f(c,syncard))
end
function s.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
	g:AddCard(c)
	local ct=g:GetCount()
	local res=s.syngoal(g,tp,lv,syncard,minc,ct)
		or (ct<maxc and mg:IsExists(s.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
	g:RemoveCard(c)
	return res
end
function s.syngoal(g,tp,lv,syncard,minc,ct)
	return ct>=minc
		and g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
		and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
		and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)<=1
		and aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL)
end
function s.syntg(e,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()
	if lv<=c:GetLevel() then return false end
	local g=Group.FromCards(c)
	local mg=Duel.GetSynchroMaterial(tp):Filter(s.synfilter,c,syncard,c,f)
	local exg=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_HAND,0,c,syncard,c,f)
	mg:Merge(exg)
	return mg:IsExists(s.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function s.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	local g=Group.FromCards(c)
	local mg=Duel.GetSynchroMaterial(tp):Filter(s.synfilter,c,syncard,c,f)
	local exg=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_HAND,0,c,syncard,c,f)
	mg:Merge(exg)
	for i=1,maxc do
		local cg=mg:Filter(s.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if s.syngoal(g,tp,lv,syncard,minc,i) then
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=cg:Select(tp,minct,1,nil)
		if sg:GetCount()==0 then break end
		g:Merge(sg)
	end
	Duel.SetSynchroMaterial(g)
end

----------------------------------------------------------------
-- ①
----------------------------------------------------------------
function s.rmfilter(c)
	return c:IsSetCard(0x104f) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
-- 候选：必须是爆裂体，且“没被已经选中的组”出现过同名
function s.rmselect(c,sg)
	return s.rmfilter(c) and not sg:IsExists(Card.IsCode,1,nil,c:GetCode())
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local pool=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	local maxct=math.min(4,pool:GetClassCount(Card.GetCode))
	if chk==0 then
		-- 至少能选到1只
		return maxct>0
	end

	-- 逐次选择：第1次必须选1只；之后每次可选0或1，选0则停止
	local sg=Group.CreateGroup()
	for i=1,maxct do
		local cg=pool:Filter(s.rmselect,sg,sg)
		if cg:GetCount()==0 then break end
		local minct=(i==1) and 1 or 0
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=cg:Select(tp,minct,1,nil)
		if tg:GetCount()==0 then break end
		sg:Merge(tg)
	end

	e:SetLabel(sg:GetCount())
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and ct>0 and c:IsFaceup() then
		--等级下降：到回合结束（按你给的示例的reset写法）
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-ct)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end

----------------------------------------------------------------
-- ②
----------------------------------------------------------------
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function s.tdfilter(c)
	return aux.IsCodeListed(c,80280737) and c:IsAbleToDeck()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsAbleToHand()
			and Duel.IsPlayerCanDraw(tp,1)
			and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	--给对方观看
	Duel.ConfirmCards(1-tp,sg)
	--回到卡组
	if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
	--那之后
	Duel.BreakEffect()
	if not c:IsRelateToEffect(e) then return end
	--这张卡加入手卡
	if Duel.SendtoHand(c,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,c)
	--自己抽1张
	Duel.Draw(tp,1,REASON_EFFECT)
end

