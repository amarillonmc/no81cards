-- 神威·不落日
Duel.LoadScript("c53702500.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	SNNM.MultiDual(c)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_ACTIVATING)
		ge2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
		ge2:SetOperation(cm.chkop)
		Duel.RegisterEffect(ge2,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetOperation(cm.sop)
	c:RegisterEffect(e1)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(cm.val)
	c:RegisterEffect(e3)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(cm.regop)
	c:RegisterEffect(e5)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetLabelObject(e5)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end

function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	--local tp=e:GetHandlerPlayer()
	Duel.RegisterFlagEffect(0,m,RESET_CHAIN,0,1)
	for tc in aux.Next(eg) do
		tc:RegisterFlagEffect(m,RESET_CHAIN,0,1)
	end
end

function cm.chkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m+10000000)==0 then
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,e,r,rp,ep,ev)
		Duel.RegisterFlagEffect(tp,m+10000000,RESET_CHAIN,0,1)
	end
end

function cm.fil(c)
	return c:GetFlagEffect(m)~=0 and not c:IsLocation(LOCATION_ONFIELD)
end

function cm.sop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if not c:IsSummonable(true,e) then return end
	local g=Duel.GetMatchingGroup(cm.fil,tp,0x3ff,0x3ff,nil)
	if #g==0 then return end
	if Duel.SendtoGrave(g,REASON_SUMMON)~=0 then
		Duel.Summon(tp,c,true,nil)
		c:SetMaterial(g)
	end
end

function cm.val(e,c)
	return (SNNM.MultiDualCount(e:GetHandler())+1)*500
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=e:GetLabelObject():GetLabel()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE) and num~=0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local num=e:GetLabelObject():GetLabel()
		for i=1,num do
			local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,0,nil)
			if #g~=1 then
				for i=1,#g-1 do
					g:RemoveCard(g:GetFirst())
				end
			end
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=SNNM.MultiDualCount(c)
	e:SetLabel(ct)
end