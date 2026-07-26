-- 熔岩白鸽

local s,id,o=GetID()
function s.initial_effect(c)
	--①：特殊召唤并装备
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+1)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--②：从卡组加入手卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,id+2)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
s.listed_series={0x39}

--自己怪兽区·墓地的「熔岩」怪兽
function s.lvfilter(c,tp)
	return c:IsControler(tp)
		and c:IsLocation(LOCATION_MZONE+LOCATION_GRAVE)
		and c:IsType(TYPE_MONSTER)
		and c:IsSetCard(0x39)
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end

--可以成为①的对象并作为装备卡处理
function s.eqfilter(c,e,tp)
	return s.lvfilter(c,tp)
		and not c:IsType(TYPE_TOKEN)
		and not c:IsForbidden()
		and c:IsCanBeEffectTarget(e)
end

--检查上一连锁是否为自己怪兽区·墓地的「熔岩」怪兽发动的怪兽效果
function s.prevchainfilter(tp)
	local ct=Duel.GetCurrentChain()
	if ct<2 then return false,nil end
	local te,p,cp,loc=Duel.GetChainInfo(
		ct-1,
		CHAININFO_TRIGGERING_EFFECT,
		CHAININFO_TRIGGERING_PLAYER,
		CHAININFO_TRIGGERING_CONTROLER,
		CHAININFO_TRIGGERING_LOCATION
	)
	local tc=te and te:GetHandler()
	local res=te
		and tc
		and p==tp
		and cp==tp
		and te:IsActiveType(TYPE_MONSTER)
		and (loc==LOCATION_MZONE or loc==LOCATION_GRAVE)
		and tc:IsSetCard(0x39)
	return res,tc
end

--取得①能够选择的对象
function s.gettg(e,tp,ev,re,rp)
	local g=Group.CreateGroup()
	--当前发动的效果以自己怪兽区·墓地的「熔岩」怪兽为对象
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg then
		local g1=tg:Filter(
			aux.NecroValleyFilter(s.eqfilter),
			nil,e,tp
		)
		g:Merge(g1)
	end
	--对方连锁自己怪兽区·墓地的「熔岩」怪兽效果发动效果
	if rp==1-tp then
		local res,tc=s.prevchainfilter(tp)
		if res and aux.NecroValleyFilter(s.eqfilter)(tc,e,tp) then
			g:AddCard(tc)
		end
	end
	return g
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	--当前效果以自己怪兽区·墓地的「熔岩」怪兽为对象
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local b1=re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
		and tg
		and tg:IsExists(s.lvfilter,1,nil,tp)
	--对方连锁自己怪兽区·墓地的「熔岩」怪兽效果发动效果
	local b2=false
	if rp==1-tp then
		b2=s.prevchainfilter(tp)
	end
	return b1 or b2
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=s.gettg(e,tp,ev,re,rp)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and #g>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:Select(tp,1,1,nil)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(
		0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND
	)
	Duel.SetOperationInfo(
		0,CATEGORY_EQUIP,sg,1,tp,0
	)
end

function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e)
		or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	if Duel.SpecialSummon(
		c,0,tp,tp,false,false,POS_FACEUP
	)==0 then
		return
	end
	if not tc
		or not tc:IsRelateToEffect(e)
		or not c:IsFaceup()
		or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
		return
	end
	if aux.NecroValleyNegateCheck(tc) then return end
	if not Duel.Equip(tp,tc,c,true) then return end
	--只能装备给这张卡
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetLabelObject(c)
	e1:SetValue(s.eqlimit)
	tc:RegisterEffect(e1)
end

--②
function s.thfilter(c)
	return c:IsSetCard(0x39)
		and c:IsType(TYPE_MONSTER)
		and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(
			s.thfilter,tp,LOCATION_DECK,0,1,nil
		)
	end
	Duel.SetOperationInfo(
		0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK
	)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(
		tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil
	)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
	end
end
