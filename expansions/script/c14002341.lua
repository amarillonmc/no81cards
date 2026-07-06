--梦境显临之乡
local m=14002341
local cm=_G["c"..m]
cm.named_with_Urara=1
function cm.initial_effect(c)
	--act
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--mark1
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(14002342)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(cm.has_con)
	c:RegisterEffect(e2)
	--mark2
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(14002341)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.ura_con)
	c:RegisterEffect(e3)
	--addtype
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ADD_TYPE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCondition(cm.tok_con)
	e4:SetTarget(cm.tok_tg)
	e4:SetValue(TYPE_TOKEN)
	c:RegisterEffect(e4)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(cm.thcost)
	e5:SetTarget(cm.thtg)
	e5:SetOperation(cm.thop)
	c:RegisterEffect(e5)
	if not UraraG_fieldcheck then
		UraraG_fieldcheck=UraraG_fieldcheck or {}
		UraraG_fieldcheck.counter=UraraG_fieldcheck.ounter or {}
		UraraG_fieldcheck.release=UraraG_fieldcheck.release or {}
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(function()
			for p=0,1 do
				local fc_rel=UraraG_fieldcheck.release[p]
				if not fc_rel or type(fc_rel)~="userdata" or fc_rel:IsHasEffect(14002341)==nil or fc_rel:GetFlagEffect(14002341)>0 then
					local g1=Duel.GetMatchingGroup(function(c) return c:IsHasEffect(14002341)~=nil and c:GetFlagEffect(14002341)==0 end,p,LOCATION_ONFIELD,0,nil)
					UraraG_fieldcheck.release[p]=g1:GetFirst() or nil
				end
				local fc_ct=UraraG_fieldcheck.counter[p]
				if not fc_ct or type(fc_ct)~="userdata" or fc_ct:IsHasEffect(14002342)==nil or fc_ct:GetFlagEffect(14002342)>0 then
					local g2 = Duel.GetMatchingGroup(function(c) return c:IsHasEffect(14002342)~=nil and c:GetFlagEffect(14002342)==0 end, p, LOCATION_ONFIELD, 0, nil)
					UraraG_fieldcheck.counter[p] = g2:GetFirst() or nil
				end
			end
		end)
		Duel.RegisterEffect(ge1, 0)
	end
end
function cm.Hastur(c)
	local m_code=_G["c"..c:GetCode()]
	return m_code and m_code.named_with_Hastur
end
function cm.Urara(c)
	local m_code=_G["c"..c:GetCode()]
	return m_code and m_code.named_with_Urara
end
function cm.has_filter(c)
	return c:IsFaceup() and cm.Hastur(c)
end
function cm.has_con(e)
	return Duel.IsExistingMatchingCard(cm.has_filter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

function cm.ura_filter(c)
	return c:IsFaceup() and cm.Urara(c)
end
function cm.ura_con(e)
	return Duel.IsExistingMatchingCard(cm.ura_filter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

function cm.tok_filter(c)
	return c:IsFaceup() and c:IsType(TYPE_TOKEN)
end
function cm.tok_con(e)
	return Duel.IsExistingMatchingCard(cm.tok_filter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.tok_tg(e,c)
	if not c or c:IsType(TYPE_TOKEN) then return end
	return c:GetCounter(0x1402)>0
end
function cm.threlfilter(c)
	return c:IsType(TYPE_TOKEN) and c:IsReleasable()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.threlfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.threlfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end