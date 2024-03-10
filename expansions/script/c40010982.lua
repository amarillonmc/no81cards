--天泪骑士-兰布罗斯
local m=40010982
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),6,2,nil,nil,99) 
	--  
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetCondition(cm.xxcon) 
	e1:SetOperation(cm.xxop) 
	c:RegisterEffect(e1) 
	--to ex sp th 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)  
	e2:SetCondition(aux.dsercon) 
	e2:SetCost(cm.spthcost)
	e2:SetTarget(cm.spthtg)
	e2:SetOperation(cm.spthop)
	c:RegisterEffect(e2)
end
function cm.xxcon(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetHandler():GetOverlayGroup()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and og:GetCount()>0 and og:FilterCount(Card.IsSetCard,nil,0xcf1a)==og:GetCount() 
end 
function cm.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,m)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE) 
	e1:SetTargetRange(1,1) 
	e1:SetValue(cm.actlimit) 
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp)  
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_MSET)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SSET)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_TURN_SET)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
	e4:SetTarget(cm.sumlimit)
	Duel.RegisterEffect(e4,tp)
end 
function cm.actlimit(e,re,tp) 
	local rc=re:GetHandler()
	return not rc:IsOnField()
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0
end
function cm.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) 
end 
function cm.spthcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup() 
	local sg=g:Filter(cm.spfil,nil,e,tp)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() and Duel.GetMZoneCount(tp,e:GetHandler())>0 and sg:GetCount()>0 end 
	g:KeepAlive()
	e:SetLabelObject(g)
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKTOP,REASON_COST) 
end 
function cm.spthtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
	local g=e:GetLabelObject()  
	local sg=g:Filter(cm.spfil,nil,e,tp):Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	if sg:GetCount()<ft then ft=sg:GetCount() end 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,ft,0,0)
end 
function cm.sckfil(c) 
	return c:IsFaceup() and c:IsSetCard(0xcf1a)
end 
function cm.spthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject() 
	local sg=g:Filter(cm.spfil,nil,e,tp):Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	if sg:GetCount()<ft then ft=sg:GetCount() end 
	if ft==0 then return end 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end 
	local ssg=sg:Select(tp,ft,ft,nil) 
	if Duel.SpecialSummon(ssg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then 
		Duel.BreakEffect()  
		local x=0
		while Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.sckfil,tp,LOCATION_MZONE,0,2,nil) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>2 and x==0 do 
			if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
				local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,1,nil) 
				Duel.SendtoHand(tg,nil,REASON_EFFECT) 
			else 
				x=1 
			end  
		end 
	end  
end 







