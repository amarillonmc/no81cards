--派对狂欢穆克拉
local m=7439223
local cm=_G["c"..m]

cm.named_with_party_time=1

function cm.Party_time(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_party_time
end

function cm.initial_effect(c)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.cptg)
	e1:SetOperation(cm.cpop)
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
function cm.cpfilter(c,e,tp,tid)
	return c:GetTurnID()~=tid and not c:IsReason(REASON_RETURN) and ((c:IsType(TYPE_SPELL+TYPE_TRAP) and c:CheckActivateEffect(true,true,false)~=nil) or (c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.gcheck(g,ft)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=ft
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tid=Duel.GetTurnCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and cm.cpfilter(chkc,e,tp,tid) end
	if chk==0 then return true end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.GetMatchingGroup(cm.cpfilter,tp,0,LOCATION_GRAVE,nil,e,tp,tid)
	if not g or #g==0 then return end
	local b1=math.min(g:FilterCount(Card.IsType,nil,TYPE_MONSTER),ft)
	local b2=g:FilterCount(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)
	local ct=math.min(b1+b2,5)
	local sg=g:SelectSubGroup(tp,cm.gcheck,false,ct,ct,ft)
	Duel.SetTargetCard(sg)
	local sumg=sg:Filter(Card.IsType,nil,TYPE_MONSTER)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sumg,#sumg,tp,LOCATION_GRAVE)
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tid=Duel.GetTurnCount()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g or #g==0 then return end
	local g=g:Filter(Card.IsRelateToEffect,nil,e)
	local sg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
	local cg=g:Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)
	if g:GetCount()>0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if sg and sg:GetCount()>0 and ft>0 then
			if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
			if sg:GetCount()>ft then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				sg=sg:Select(tp,ft,ft,nil)
			end
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
		if cg and cg:GetCount()>0 then
			local tc=cg:GetFirst()
			while tc do
				Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
				local te=tc:GetActivateEffect()
				if not te then
				else
					local target=te:GetTarget()
					local operation=te:GetOperation()
					if tc:CheckActivateEffect(true,true,false)~=nil
						and (not target or target(te,tp,eg,ep,ev,re,r,rp,0)) then
						Duel.ClearTargetCard()
						e:SetProperty(te:GetProperty())
						tc:CreateEffectRelation(te)
						if target then target(te,tp,eg,ep,ev,re,r,rp,1) end
						local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
						local tg=g:GetFirst()
						while tg do
							tg:CreateEffectRelation(te)
							tg=g:GetNext()
						end
						if operation then operation(te,tp,eg,ep,ev,re,r,rp) end
						tc:ReleaseEffectRelation(te)
						tg=g:GetFirst()
						while tg do
							tg:ReleaseEffectRelation(te)
							tg=g:GetNext()
						end
					end
				end
				tc=cg:GetNext()
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
