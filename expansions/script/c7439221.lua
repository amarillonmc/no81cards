--派对狂欢穆克拉
local m=7439221
local cm=_G["c"..m]

cm.named_with_party_time=1

function cm.Party_time(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_party_time
end

function cm.initial_effect(c)
	--select
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.sltg)
	e1:SetOperation(cm.slop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(cm.spcon)
	e5:SetTarget(cm.sptg)
	e5:SetOperation(cm.spop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e6)
end
function cm.sltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.slop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)>=8 then
		local b1=Duel.GetFieldGroupCount(1-c:GetOwner(),0,LOCATION_DECK)>=5
		local b2=Duel.GetFieldGroupCount(1-c:GetOwner(),0,LOCATION_HAND)>=2
		local g3=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,c:GetOwner(),0,LOCATION_MZONE,nil)
		local b3=g3:GetCount()>0
		if not b1 and not b2 and not b3 then return end
		local op=0
		if b1 and not b2 and not b3 then op=Duel.SelectOption(c:GetOwner(),aux.Stringid(m,3))
		elseif not b1 and b2 and not b3 then op=Duel.SelectOption(c:GetOwner(),aux.Stringid(m,4))+1
		elseif not b1 and not b2 and b3 then op=Duel.SelectOption(c:GetOwner(),aux.Stringid(m,5))+2
		elseif b1 and b2 and not b3 then op=Duel.SelectOption(c:GetOwner(),aux.Stringid(m,3),aux.Stringid(m,4))
		elseif b1 and not b2 and b3 then op=Duel.SelectOption(c:GetOwner(),aux.Stringid(m,3),aux.Stringid(m,5)) if op==1 then op=2 end
		elseif not b1 and b2 and b3 then op=Duel.SelectOption(c:GetOwner(),aux.Stringid(m,4),aux.Stringid(m,5))+1
		else op=Duel.SelectOption(c:GetOwner(),aux.Stringid(m,3),aux.Stringid(m,4),aux.Stringid(m,5)) end
		if op==0 then
			local g=Duel.GetDecktopGroup(1-tp,5)
			if #g>0 then
				Duel.BreakEffect()
				Duel.DisableShuffleCheck()
				Duel.SendtoHand(g,c:GetOwner(),REASON_EFFECT)
			end
		elseif op==1 then
			local g=Duel.GetFieldGroup(c:GetOwner(),0,LOCATION_HAND):RandomSelect(c:GetOwner(),2)
			Duel.SendtoHand(g,c:GetOwner(),REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG,c:GetOwner(),HINTMSG_CONTROL)
			local g=g3:Select(c:GetOwner(),1,1,nil)
			local tc=g:GetFirst()
			if tc then
				Duel.GetControl(tc,c:GetOwner())
			end
		end
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=false
	local b2=false
	local b3=false
	if re and re:GetHandler() then
		b1=(pl==1-c:GetOwner())
	end
	if c:GetReasonCard() then
		b2=(c:GetReasonCard():GetControler()==1-c:GetOwner())
	end
	if c:GetReasonEffect() and c:GetReasonEffect():GetHandler() then
		b3=(c:GetReasonEffect():GetHandlerPlayer()==1-c:GetOwner())
	end
	return (c:GetReasonPlayer()==1-c:GetOwner() or b1 or b2 or b3) and (not (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
