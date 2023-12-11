local m=15005200
local cm=_G["c"..m]
cm.name="坠镞为林-柯莱"
function cm.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+15005200)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--on-summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,15005200)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.target)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	if not TddSkandhaGlobalCheck then
		TddSkandhaGlobalCheck=true
		_SkandhaCRemoveCounter=Card.RemoveCounter
		function Card.RemoveCounter(tc,p,countertype,ct,r,re)
			if countertype==0 then
				local count=tc:GetCounter(0x1f37)
				if count>0 and not re then
					Duel.RaiseEvent(tc,EVENT_REMOVE_COUNTER+0x1f37,nil,r,p,tc:GetControler(),count)
				elseif count>0 and re then
					Duel.RaiseEvent(tc,EVENT_REMOVE_COUNTER+0x1f37,re,r,p,tc:GetControler(),count)
				end
			end
			if countertype==0x1f37 then
				local count=tc:GetCounter(0x1f37)
				if count>0 and not re then
					Duel.RaiseEvent(tc,EVENT_REMOVE_COUNTER+0x1f37,nil,r,p,tc:GetControler(),ct)
				elseif count>0 and re then
					Duel.RaiseEvent(tc,EVENT_REMOVE_COUNTER+0x1f37,re,r,p,tc:GetControler(),ct)
				end
			end
			return _SkandhaCRemoveCounter(tc,p,countertype,ct,r)
		end
		_SkandhaDRemoveCounter=Duel.RemoveCounter
		function Duel.RemoveCounter(p,s,o,countertype,ct,r)
			if countertype~=0x1f37 then
				return _SkandhaDRemoveCounter(p,s,o,countertype,ct,r)
			end
			if s~=0 and o~=0 then
				return _SkandhaDRemoveCounter(p,s,o,countertype,ct,r)
			end
			local f=function(c)
						return c:GetCounter(0x1f37)>0
					end
			local rmg=Duel.GetMatchingGroup(f,p,s,o,nil)
			local rmg0=rmg:Filter(Card.IsControler,nil,0)
			local rmg1=rmg:Filter(Card.IsControler,nil,1)
			if #rmg0~=0 then 
				Duel.RaiseEvent(rmg0,EVENT_REMOVE_COUNTER+0x1f37,nil,r,7,0,ct)
			end
			if #rmg1~=0 then 
				Duel.RaiseEvent(rmg1,EVENT_REMOVE_COUNTER+0x1f37,nil,r,7,1,ct)
			end
			return _SkandhaDRemoveCounter(p,s,o,countertype,ct,r)
		end
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD_P)
		ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							local ct0=eg:Filter(Card.IsControler,nil,0):GetSum(Card.GetCounter,0x1f37)
							local ct1=eg:Filter(Card.IsControler,nil,1):GetSum(Card.GetCounter,0x1f37)
							e:SetLabel(ct0,ct1)
						end)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_LEAVE_FIELD)
		ge2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
							local ct0,ct1=e:GetLabelObject():GetLabel()
							return ct0~=0 or ct1~=0
						end)
		ge2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							local ct0,ct1=e:GetLabelObject():GetLabel()
							if ct0~=0 then
								Duel.RaiseEvent(eg,EVENT_CUSTOM+15005200,re,r,rp,0,ct0)
							end
							if ct1~=0 then
								Duel.RaiseEvent(eg,EVENT_CUSTOM+15005200,re,r,rp,1,ct1)
							end
						end)
		ge2:SetLabelObject(ge1)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CUSTOM+15005200)
		ge3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
							return ev>0
						end)
		ge3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							local x=100
							if Duel.IsPlayerAffectedByEffect(ep,15005204) then
								x=Duel.IsPlayerAffectedByEffect(ep,15005204):GetValue()
							end
							if Duel.IsPlayerAffectedByEffect(ep,15005202) then
								Duel.Recover(ep,ev*x,REASON_EFFECT)
							else
								Duel.Damage(ep,ev*x,REASON_EFFECT)
							end
						end)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_REMOVE_COUNTER+0x1f37)
		ge4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
							return ev>0 and (rp==0 or rp==1)
						end)
		ge4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							local x=100
							if Duel.IsPlayerAffectedByEffect(ep,15005204) then
								x=Duel.IsPlayerAffectedByEffect(ep,15005204):GetValue()
							end
							if Duel.IsPlayerAffectedByEffect(ep,15005202) then
								Duel.Recover(ep,ev*x,REASON_EFFECT)
							else
								Duel.Damage(ep,ev*x,REASON_EFFECT)
							end
						end)
		Duel.RegisterEffect(ge4,0)
	end
end
cm.counter_add_list={0x1f37}
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ev>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function cm.thfilter(c)
	return aux.IsCounterAdded(c,0x1f37) and c:IsAbleToHand() and not c:IsCode(15005200)
end
function cm.ctfilter(c)
	return c:IsCanAddCounter(0x1f37,1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,3)},{b2,aux.Stringid(m,4)})
	if op==1 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		e:SetOperation(cm.search)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_COUNTER)
		e:SetOperation(cm.ctplace)
	end
end
function cm.search(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g~=0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.ctplace(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,cm.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if #g~=0 then
		g:GetFirst():AddCounter(0x1f37,1)
		Duel.RaiseEvent(g:GetFirst(),EVENT_CUSTOM+15005201,e,0,tp,tp,1)
	end
end