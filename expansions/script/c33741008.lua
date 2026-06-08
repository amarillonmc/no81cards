--Echoes Kernel #Mα - Sepia Tone
local s,id,o=GetID()
Duel.LoadScript("c33741000.lua")
function s.initial_effect(c)
	DEchoes.AddKernelFusion(c,RACE_WARRIOR)
	DEchoes.AddGrantTrigger(c,id,s.grant)
end
function s.rvfilter(c)
	return DEchoes.IsEchoes(c) and c:IsType(TYPE_MONSTER)
end
function s.setfilter(c)
	return DEchoes.IsDEchoes(c) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function s.maxcount(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return 0 end
	local eg=Duel.GetMatchingGroup(s.rvfilter,tp,LOCATION_EXTRA,0,nil)
	local dg=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil)
	return math.min(5,ft,eg:GetClassCount(Card.GetCode),dg:GetClassCount(Card.GetCode))
end
function s.grant(e,tc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.setcost)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=s.maxcount(tp)
	if chk==0 then return ct>0 end
	local g=Duel.GetMatchingGroup(s.rvfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	if not sg then
		e:SetLabel(0)
		return
	end
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleExtra(tp)
	e:SetLabel(sg:GetCount())
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_SSET,nil,ct,tp,LOCATION_DECK)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct<=0 or Duel.GetLocationCount(tp,LOCATION_SZONE)<ct then return end
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<ct then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
	if sg and sg:GetCount()==ct then
		Duel.SSet(tp,sg)
	end
end
