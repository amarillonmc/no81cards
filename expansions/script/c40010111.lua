--顶峰超越之剑 崇高巴斯提昂
local m=40010111
local cm=_G["c"..m]

function cm.KeterSanctuary(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_KeterSanctuary
end

function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon1)
	e2:SetOperation(cm.sprop1)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetCondition(cm.sprcon2)
	e3:SetOperation(cm.sprop2)
	c:RegisterEffect(e3) 
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCost(cm.copycost)
	e4:SetOperation(cm.copyoperation)
	c:RegisterEffect(e4)
	--immune effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(cm.etarget1)
	e5:SetValue(cm.efilter1)
	c:RegisterEffect(e5)
	--negate
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(cm.discon)
	e6:SetTarget(cm.distg)
	e6:SetOperation(cm.disop)
	c:RegisterEffect(e6)

end
function cm.sprfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and c:IsRace(RACE_WARRIOR)
end
function cm.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsType(TYPE_TUNER) and c:IsRace(RACE_WARRIOR) and g:IsExists(cm.sprfilter2,1,c,tp,c,sc,lv)
end
function cm.sprfilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return c:IsLevel(lv) and not c:IsType(TYPE_TUNER) and c:IsRace(RACE_WARRIOR)
		and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function cm.sprcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(cm.sprfilter1,1,nil,tp,g,c)
end
function cm.sprop1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,cm.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,cm.sprfilter2,1,1,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function cm.sprcon2(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(REASON_COST,c:GetControler(),Card.IsCode,1,nil,40009559)
end
function cm.sprop2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(REASON_COST,tp,Card.IsCode,1,1,nil,40009559)
	Duel.Release(g,REASON_COST)
end

function cm.etarget1(e,c)
	return c:IsRace(RACE_WARRIOR) 
end
function cm.efilter1(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_TRAP)
end
function cm.filter(c)
	return c:IsCode(40009559) and c:IsAbleToRemoveAsCost()
end
function cm.copycost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetOriginalCode())
end
function cm.copyoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and tc:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsLevelAbove(8) and tc:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
			Duel.ShuffleHand(tp)
			Duel.NegateActivation(ev)
		end
	else
		Duel.MoveSequence(tc,1)
	end
end
