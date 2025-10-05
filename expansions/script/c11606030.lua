--绝海滋养的安康鱼
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
    --自己主要阶段才能发动。从双方墓地以及除外的卡中，选这张卡等级每2星最多1张的卡回到持有者卡组。那之后，可以进行1只「绝海滋养」怪兽的召唤。
    --「黎溟界辟」「闪刀亚式-双纽闪门」「异响鸣的继承」「吞食圣痕之龙」
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.con)
	e3:SetTarget(s.tdtg)
	e3:SetOperation(s.tdop)
	c:RegisterEffect(e3)
	local e3q=e3:Clone()
	e3q:SetType(EFFECT_TYPE_QUICK_O)
	e3q:SetCode(EVENT_FREE_CHAIN)
	e3q:SetHintTiming(0,TIMING_MAIN_END)
	e3q:SetCondition(s.qcon)
	c:RegisterEffect(e3q)
    --这张卡被解放的场合才能发动。这个回合只有1次，自己把「绝海滋养」怪兽上级召唤的场合，也能从卡组把最多2只「绝海滋养」怪兽解放。
    --「帝王的烈旋」「古代的机械城」「被埋葬的牲祭」
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_RELEASE)
	e4:SetCountLimit(1,id+o)
	e4:SetOperation(s.ersop)
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
function s.tdfilter(c)
	return c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil)
    local ct=e:GetHandler():GetLevel()//2
	if chk==0 then return #g>0 and ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.ofilter(c,p)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(p)
end
function s.sumfilter(c)
	return c:IsSummonable(true,nil) and c:IsSetCard(0x5225)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local ct=c:GetLevel()//2
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end --「抒情歌鸲-独立夜莺」
    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
    ct=math.min(#g,ct)
    if ct==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local tg=g:Select(tp,1,ct,nil)
    --「灵魂鸟神-姬孔雀」
    if Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
        local og=Duel.GetOperatedGroup()
		if not og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then return end
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
function s.ersop(e,tp,eg,ep,ev,re,r,rp)
	--「古代的机械城」「被埋葬的牲祭」
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,4))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCondition(s.sumcon)
	e1:SetTarget(s.sumtg)
	e1:SetOperation(s.sumop)
	e1:SetCountLimit(1)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.sumtg(e,c)
	return c:IsSetCard(0x5225)
end
function s.IsAdanceable(e,c)
	local min,max=c:GetTributeRequirement()
	if max>0 then return true end --「古代的机械城」
	local es={c:IsHasEffect(EFFECT_SUMMON_PROC)}
	local res=false
	for _,se in ipairs(es) do
		if se~=e and se:GetValue()&SUMMON_TYPE_ADVANCE==SUMMON_TYPE_ADVANCE then
			res=true
			break
		end
	end
	return res
end
function s.GetFieldTributeGroup(c)
	local tp=c:GetControler()
	local g=Duel.GetReleaseGroup(tp,true,REASON_SUMMON)
	return g
end
function s.tfilter(c)
	return c:IsSetCard(0x5225) and c:IsType(TYPE_MONSTER)
end
function s.sumcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local min=minc
	if minc==0 then min=1 end
	--if min<minc then min=minc end
	local mg=Duel.GetMatchingGroup(s.tfilter,tp,LOCATION_DECK,0,nil):Filter(Card.IsReleasable,nil,REASON_SUMMON) --「古代的机械城」
	return s.IsAdanceable(e,c)
		and mg:CheckSubGroup(s.mfilter,0,min,c,tp,min)
		--Duel.CheckTribute(c,minc,minc,mg) --「大太郎法师」
end
function s.mfilter(sg,c,tp,minc)
	local res=true
	local res2=Duel.GetMZoneCount(tp,sg)>0
	local ct=minc-#sg
	if ct~=0 then
		res=Duel.CheckTribute(c,ct)
		res2=true
	end
	return #sg<=2 --and Duel.CheckTribute(c,#sg,#sg,sg)
		and res
		and res2
end
function s.m2filter(sg,mg,c,tp,minc)
	local g=sg+mg
	return #sg<=2 --and Duel.CheckTribute(c,#sg,#sg,sg)
		and #g>=minc
		and Duel.GetMZoneCount(tp,g)>0
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp,c,minc)
	if minc==0 then minc=1 end
	local dg=Duel.GetMatchingGroup(s.tfilter,tp,LOCATION_DECK,0,nil):Filter(Card.IsReleasable,nil,REASON_SUMMON) --「古代的机械城」
	local mg=Group.CreateGroup()
	if Duel.CheckTribute(c,1) and (math.min(#dg,2)<minc or  Duel.SelectYesNo(tp,aux.Stringid(id,5))) then
		local mg1=Duel.SelectTribute(tp,c,0,149)
		mg=mg+mg1
	end
	if #mg<minc or Duel.SelectYesNo(tp,aux.Stringid(id,6)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,7))
		local mg2=dg:SelectSubGroup(tp,s.m2filter,false,0,2,mg,c,tp,minc)
		if mg2 then mg=mg+mg2 end
	end
	if #mg==0 then return end
	c:SetMaterial(mg)
	Duel.Release(mg,REASON_SUMMON+REASON_MATERIAL)
end