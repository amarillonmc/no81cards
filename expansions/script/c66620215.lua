--绮奏·殁音神威 赫尔提亚
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	
	-- 属性不同的机械族怪兽×3
	aux.AddFusionProcFunRep(c,s.ffilter,3,true)
	
	-- 这张卡不会成为对方的效果的对象
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	
	-- 对方场上有怪兽特殊召唤的场合，以那之内的1只为对象才能发动，那只怪兽破坏，给与对方那个原本攻击力数值的伤害
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,id,EVENT_SPSUMMON_SUCCESS)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(custom_code)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.desdcon)
	e2:SetTarget(s.desdtg)
	e2:SetOperation(s.desdop)
	c:RegisterEffect(e2)
	
	-- 融合召唤的这张卡因对方从场上离开的场合才能发动，对方的手卡·场上1张卡破坏（从手卡是随机选）
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.descon)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
end

-- 属性不同的机械族怪兽×3
function s.ffilter(c,fc,sub,mg,sg)
	return c:IsRace(RACE_MACHINE) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end

-- 对方场上有怪兽特殊召唤的场合，以那之内的1只为对象才能发动，那只怪兽破坏，给与对方那个原本攻击力数值的伤害
function s.desfilter(c,tp,e)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(1-tp) and c:IsCanBeEffectTarget(e)
end

function s.desdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end

function s.desdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=eg:Filter(s.desfilter,nil,tp,e)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g>0 end
	local sg
	if g:GetCount()==1 then
		sg=g:Clone()
		Duel.SetTargetCard(sg)
	else
		Duel.Hint(HINTMSG_DESTROY,tp,HINTMSG_DESTROY)
		sg=Duel.SelectTarget(tp,aux.IsInGroup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
	if sg:GetFirst():IsFaceup() and math.max(0,sg:GetFirst():GetTextAttack())>0 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
	end
end

function s.desdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local atk=math.max(0,tc:GetTextAttack())
		if atk>0 then
			Duel.Damage(1-tp,math.floor(atk),REASON_EFFECT)
		end
	end
end

-- 融合召唤的这张卡因对方从场上离开的场合才能发动，对方的手卡·场上1张卡破坏（从手卡是随机选）
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_HAND)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local fg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local g
	if #hg>0 and (#fg==0 or Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))==0) then
		g=hg:RandomSelect(tp,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	end
	if g:GetCount()~=0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
