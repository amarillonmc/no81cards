local m=82206100
local cm=c82206100

--苍穹之望·艾希丝
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,cm.lcheck)
	c:EnableReviveLimit() 
	--cannot remove  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(EFFECT_CANNOT_REMOVE)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetTargetRange(1,1)  
	e1:SetTarget(cm.rmlimit)  
	c:RegisterEffect(e1) 
	--disable 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_DISABLE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetProperty(EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)  
	e2:SetTarget(cm.distg)  
	c:RegisterEffect(e2)  
	--get 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,m)  
	e3:SetTarget(cm.gttg)
	e3:SetOperation(cm.gtop) 
	c:RegisterEffect(e3)	
end

function cm.lcheck(g)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_WIND)
end

function cm.rmlimit(e,c,tp,r)  
	return c==e:GetHandler() and r==REASON_EFFECT  
end
function cm.cznfil(c,e,tp,p,seq2) 
	local seq1=c:GetSequence()
	seq1=aux.MZoneSequence(seq1)
	if c:GetControler()~=p then
		seq1=4-seq1
	end
	return e:GetHandler():GetLinkedGroup():IsContains(c) and math.abs(seq1-seq2)==1
end
function cm.ckfil(c,e,tp) 
	local p=c:GetControler()
	local seq2=c:GetSequence()
	seq2=aux.MZoneSequence(seq2)
	return Duel.IsExistingMatchingCard(cm.cznfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,p,seq2) 
end
function cm.distg(e,c)
	local tp=e:GetHandler():GetControler()
	local xg=Duel.GetMatchingGroup(cm.ckfil,tp,0,LOCATION_MZONE,nil,e,tp) 
	return c~=e:GetHandler() and xg:IsContains(c)
end
function cm.xckfil(c,tp) 
	return c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT)
end 
function cm.gttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.xckfil,1,nil,tp) end 
end  
function cm.gtop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	--  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.xgttg)
	e1:SetCondition(cm.xgtcon)
	e1:SetOperation(cm.xgtop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetLabelObject(e1)
	e2:SetCondition(cm.xgtcon)
	e2:SetOperation(cm.clearop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end
function cm.xgtcon(e,tp)
	return Duel.GetTurnPlayer()==tp
end  
function cm.clearop(e,tp,eg,ep,ev,re,r,rp)   
	local te=e:GetLabelObject()
	te:Reset()
	e:Reset()
end
function cm.xgttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local zone1=e:GetHandler():GetLinkedZone(tp) 
	local zone2=e:GetHandler():GetLinkedZone(1-tp)
	if chk==0 then return e:GetHandler():GetSequence()>4 and (Duel.GetLocationCount(tp,LOCATION_MZONE,zone1)>0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE,zone2)>0) and Duel.IsPlayerCanSpecialSummonMonster(tp,82206101,nil,TYPES_TOKEN_MONSTER,0,0,1,RACE_FAIRY,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0) 
end  
function cm.xgtop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local zone1=e:GetHandler():GetLinkedZone(tp) 
	local zone2=e:GetHandler():GetLinkedZone(1-tp) 
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE,zone1)>0
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,zone2)>0
	if (b1 or b2) and Duel.IsPlayerCanSpecialSummonMonster(tp,82206101,nil,TYPES_TOKEN_MONSTER,0,0,1,RACE_FAIRY,ATTRIBUTE_WIND) then 
	local op=3 
	if b1 and b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))  
	elseif b1 then 
	op=Duel.SelectOption(tp,aux.Stringid(m,2)) 
	elseif b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(m,3))+1 
	end  
	local zone=0 
	local p=tp
	if op==0 then zone=zone1 end 
	if op==1 then zone=zone2 p=1-tp end   
		local token=Duel.CreateToken(tp,82206101)
		Duel.SpecialSummonStep(token,0,tp,p,false,false,POS_FACEUP,zone) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_UNRELEASABLE_SUM)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e2,true)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		token:RegisterEffect(e3,true)
		Duel.SpecialSummonComplete()
	end
end



