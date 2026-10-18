--织巢之痕 忠指献义者
local s,id=GetID()

s.VHisc_WEAVENEST=true
s.VHisc_ZHONGZHI=true
local CARD_RYOSHU=33310451
local CARD_HUFU=33310464

s.listed_series={SET_ZHICHAO,SET_ZHONGZHI}
s.listed_names={CARD_RYOSHU,CARD_HUFU}

function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptarget)
	e1:SetOperation(s.spoperation)
	c:RegisterEffect(e1)
	--②：对方场上攻击力最高的怪兽发动效果时回收
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id+10000)
	e3:SetCondition(s.selfcon)
	e3:SetTarget(s.selftg)
	e3:SetOperation(s.selfop)
	c:RegisterEffect(e3)
	--③：给予「斩烬织巢之刃 良秀」效果
	local ge=Effect.CreateEffect(c)
	ge:SetDescription(aux.Stringid(id,2))
	ge:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ge:SetCode(EVENT_BATTLE_START)
	ge:SetCondition(s.btcon)
	ge:SetOperation(s.btop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(s.grantcon)
	e4:SetTarget(s.granttg)
	e4:SetLabelObject(ge)
	c:RegisterEffect(e4)
end

--1
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function s.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.handspfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and (c.VHisc_WEAVENEST or c.VHisc_ZHONGZHI) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end
function s.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.handspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end


--②
function s.highatkfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk
end

function s.selfcon(e,tp,eg,ep,ev,re,r,rp)
	if rp~=1-tp or not re:IsActiveType(TYPE_MONSTER) then return false end
	local rc=re:GetHandler()
	return rc:IsFaceup() and rc:IsControler(1-tp) and rc:IsLocation(LOCATION_MZONE)
		and not Duel.IsExistingMatchingCard(s.highatkfilter,tp,0,LOCATION_MZONE,1,rc,rc:GetAttack())
end

function s.selftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	e:SetLabelObject(re:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,re:GetHandler(),1,0,0)
end

function s.hufilter(c)
	return c:IsFaceup() and c:IsCode(CARD_HUFU)
end

function s.selfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--local rc=e:GetLabelObject()
	if not c:IsRelateToEffect(e) or 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if not Duel.IsExistingMatchingCard(s.hufilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) then return end
	--if rc and rc:IsRelateToEffect(re) and rc:IsLocation(LOCATION_MZONE) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
	--	Duel.Destroy(rc,REASON_EFFECT)
	--end
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local tg=g:GetMaxGroup(Card.GetAttack)
		if #tg>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		else Duel.Destroy(tg,REASON_EFFECT) end
	end
end

--③
function s.grantcon(e)
	return e:GetHandler():IsReason(REASON_DESTROY)
end

function s.gravefilter(c)
	return c:IsCode(id) and c:IsReason(REASON_DESTROY) and not c:IsDisabled()
end

function s.granttg(e,c)
	if not c:IsFaceup() or not c:IsCode(CARD_RYOSHU) then return false end
	local h=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.gravefilter,h:GetControler(),LOCATION_GRAVE,0,nil)
	local tc=g:GetFirst()
	while tc do
		if tc~=h and tc:GetFieldID()<h:GetFieldID() then return false end
		tc=g:GetNext()
	end
	c:RegisterFlagEffect(33310451,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	return true
end

function s.btcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end

function s.btop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(300)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	Duel.Damage(1-tp,300,REASON_EFFECT)
end