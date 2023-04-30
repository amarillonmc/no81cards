--龙仪巧-处女流星=AIR
local m=11612629
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/11610000") end) then require("script/11610000") end
cm.text=zhc_lhq_cn
function c11612629.initial_effect(c)
	c:EnableReviveLimit()
	--
	local e00=fpjdiy.Zhc(c,cm.text)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.valcheck)
	c:RegisterEffect(e0)
	--cannot be effect target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	--th
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.matcon)
	e3:SetOperation(cm.matop)
	c:RegisterEffect(e3)
	e0:SetLabelObject(e3)
	--copy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,m*2+1)
	e4:SetCondition(cm.cpcon)
	e4:SetTarget(cm.cptg)
	e4:SetOperation(cm.cpop)
	c:RegisterEffect(e4)
end
function cm.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()==1
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
end
function cm.lvfilter(c,rc)
	return c:GetRitualLevel(rc)>0
end
function cm.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(cm.lvfilter,nil,c)
	if #fg>0 and fg:GetSum(Card.GetRitualLevel,c)<=2 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
--1
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and (re:GetActivateLocation()==LOCATION_GRAVE or (re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSummonLocation(LOCATION_GRAVE)) )
end
--2
function cm.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ex,g,gc,dp,dv=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	if e:GetHandler():GetFlagEffect(m)<=0 then return false end
	return (((ex and (dv&LOCATION_GRAVE==LOCATION_GRAVE or g and g:IsExists(cm.cfilter,1,nil)) or re:IsHasCategory(CATEGORY_GRAVE_SPSUMMON))) or re:GetActivateLocation()==LOCATION_GRAVE ) and Duel.IsChainNegatable(ev) and rp==1-tp
end
function cm.etfilter(c)
	return c:IsFaceup()  and  (c:GetAttack()>0 or c:GetDefense()>0 )
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
--03
function cm.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
		and e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.tfilter(c)
	return c:IsSetCard(0x154) and c:IsAbleToHand()
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bool_a=Duel.IsPlayerCanDraw(tp,1)
	local bool_b=Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return bool_a or bool_b end
	local op=0
	if bool_a and bool_b then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif bool_a then
		op=Duel.SelectOption(tp,aux.Stringid(m,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.tfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end