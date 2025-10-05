--绝海滋养的海星
local s,id,o=GetID()
function s.initial_effect(c)
	--这张卡也能把任意数量的怪兽解放来上级召唤。
	--「守墓的审神者」「神兽王 巴巴罗斯」
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(s.ttcon)
	e0:SetOperation(s.ttop)
	e0:SetValue(SUMMON_TYPE_ADVANCE+SUMMON_VALUE_SELF)
	c:RegisterEffect(e0)
	local e0s=e0:Clone()
	e0s:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e0s)
    --这张卡的等级·攻击力·守备力上升为这张卡的上级召唤而解放的怪兽的各自数值的合计
	--「暴君海王星」「天魔神 因维希尔」「加速同调士」
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(s.valcheck)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_COST)
	e2:SetOperation(s.facechk)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--自己主要阶段才能发动。这张卡等级每2星最多1张的卡尽可能从对方额外卡组随机送去墓地。那之后，可以进行1只「绝海滋养」怪兽的召唤。
    --「枪刺处刑刃」「No.1 感染蝇王 巴力·西卜」「龙骑兵团骑士-三叉龙骑士」
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.con)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
	local e3q=e3:Clone()
	e3q:SetType(EFFECT_TYPE_QUICK_O)
	e3q:SetCode(EVENT_FREE_CHAIN)
	e3q:SetHintTiming(0,TIMING_MAIN_END)
	e3q:SetCondition(s.qcon)
	c:RegisterEffect(e3q)
	--这张卡被解放的场合才能发动。从卡组把最多2只「绝海滋养」怪兽加入手卡。
	--「电子化天使-弁天-」「疾走的暗黑骑士 盖亚」
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_RELEASE)
	e4:SetCountLimit(1,id+o)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
end
function s.ttcon(e,c,minc)
	if c==nil then return true end
	local minr=minc
    if minc==0 then minr=1 end
	return Duel.CheckTribute(c,minr)
end
function s.ttop(e,tp,eg,ep,ev,re,r,rp,c,minc)
	local minr=minc
    if minc==0 then minr=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTribute(tp,c,minr,149)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function s.valcheck(e,c)
	if e:GetLabel()~=1 then return end
	e:SetLabel(0)
	local g=c:GetMaterial()
	local tc=g:GetFirst()
	local atk=0
	local def=0
	local lv=0
	while tc do
		--获取卡片信息的时机参考「天魔神 因维希尔」
		local catk=tc:GetAttack()
		local cdef=tc:GetDefense()
		local clv=0
		if tc:IsLevelAbove(1) then clv=tc:GetLevel() end
		atk=atk+(catk>=0 and catk or 0)
		def=def+(cdef>=0 and cdef or 0)
		lv=lv+clv
		tc=g:GetNext()
	end
		--atk continuous effect
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
		--def continuous effect
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(def)
		c:RegisterEffect(e2)
		--lv continuous effect
		local e3=e1:Clone()
		e3:SetCode(EFFECT_UPDATE_LEVEL)
		e3:SetValue(lv)
		c:RegisterEffect(e3)
end
function s.facechk(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(1)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not aux.IsCanBeQuickEffect(c,tp,11606068)
end
function s.qcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return aux.IsCanBeQuickEffect(c,tp,11606068)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
	local ct=e:GetHandler():GetLevel()//2
	if chk==0 then return #g>0 and ct>0 end
	ct=math.min(#g,ct)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,ct,0,0) --「灵魂游荡的墓场」「黯黑世界-暗影敌托邦-」「拓扑篡改感染龙」
end
function s.sumfilter(c)
	return c:IsSummonable(true,nil) and c:IsSetCard(0x5225)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetLevel()//2
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end --「抒情歌鸲-独立夜莺」
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
	ct=math.min(#g,ct)
	if ct==0 then return end
	local rg=g:RandomSelect(tp,ct)
	if Duel.SendtoGrave(rg,REASON_EFFECT)~=0 then --「刚鬼死斗」
		Duel.ShuffleExtra(1-tp)
		if Duel.GetOperatedGroup():IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
			if Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
				and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
				local sg=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
				if sg:GetCount()>0 then
					Duel.Summon(tp,sg:GetFirst(),true,nil)
				end
			end
		end
	end
end
function s.thfilter(c)
	return c:IsSetCard(0x5225) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end