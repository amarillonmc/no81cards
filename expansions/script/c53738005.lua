local m=53738005
local cm=_G["c"..m]
cm.name="歼世死士轮 贩子"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.detg)
	e1:SetOperation(cm.deop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(function(c)return c:IsPreviousLocation(LOCATION_DECK) and c:IsReason(REASON_DESTROY)end,nil)
	for tc in aux.Next(g) do tc:RegisterFlagEffect(53738000,RESET_EVENT+RESETS_STANDARD,0,0) end
end
function cm.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,PLAYER_ALL,LOCATION_DECK)
end
function cm.deop(e,tp,eg,ep,ev,re,r,rp)
	local ct=1
	if Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)>4 then ct=2 end
	local g=Group.__add(Duel.GetDecktopGroup(0,ct),Duel.GetDecktopGroup(1,ct))
	if #g~=2*ct then return end
	Duel.DisableShuffleCheck()
	Duel.Destroy(g,REASON_EFFECT)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(53738000)~=0 and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.__add(Duel.GetDecktopGroup(0,1),Duel.GetDecktopGroup(1,1))
	Duel.DisableShuffleCheck()
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
