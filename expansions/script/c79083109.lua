--殉道者 安多恩
function c79083109.initial_effect(c)
	c:EnableReviveLimit()   
	--Remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,79083109) 
	e1:SetCost(c79083109.rmcost)
	e1:SetTarget(c79083109.rmtg)
	e1:SetOperation(c79083109.rmop) 
	c:RegisterEffect(e1) 
	--limit 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1278431,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,19083109) 
	e2:SetTarget(c79083109.lmttg)
	e2:SetOperation(c79083109.lmtop)
	c:RegisterEffect(e2) 

end 
c79083109.named_with_Laterano=true 
function c79083109.rmcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.CheckLPCost(tp,1000) end 
	Duel.PayLPCost(tp,1000)
end
function c79083109.rmtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end 
function c79083109.dsfil(c,seq2,loc)  
	local seq1=c:GetSequence()  
	if loc==0 then return false end 
	if loc==1 then 
	if seq2==0 then return (seq1==1 and c:IsLocation(LOCATION_MZONE)) or (seq1==0 and c:IsLocation(LOCATION_SZONE))  
	elseif seq2==1 then return ((seq1==0 or seq1==2 or seq1==5) and c:IsLocation(LOCATION_MZONE)) or (seq1==1 and c:IsLocation(LOCATION_SZONE))  
	elseif seq2==2 then return ((seq1==1 or seq1==3) and c:IsLocation(LOCATION_MZONE)) or (seq1==2 and c:IsLocation(LOCATION_SZONE))  
	elseif seq2==3 then return ((seq1==2 or seq1==4 or seq1==6) and c:IsLocation(LOCATION_MZONE)) or (seq1==3 and c:IsLocation(LOCATION_SZONE))   
	elseif seq2==4 then return (seq1==3 and c:IsLocation(LOCATION_MZONE)) or (seq1==4 and c:IsLocation(LOCATION_SZONE)) 
	elseif seq2==5 then return seq1==1 and c:IsLocation(LOCATION_MZONE)
	elseif seq2==6 then return seq1==3 and c:IsLocation(LOCATION_MZONE)
	else return false end 
	elseif loc==2 then 
	if seq2==0 then return (seq1==1 and c:IsLocation(LOCATION_SZONE)) or (seq1==0 and c:IsLocation(LOCATION_MZONE))  
	elseif seq2==1 then return ((seq1==0 or seq1==2) and c:IsLocation(LOCATION_SZONE)) or (seq1==1 and c:IsLocation(LOCATION_MZONE))  
	elseif seq2==2 then return ((seq1==1 or seq1==3) and c:IsLocation(LOCATION_SZONE)) or (seq1==2 and c:IsLocation(LOCATION_MZONE))  
	elseif seq2==3 then return ((seq1==2 or seq1==4) and c:IsLocation(LOCATION_SZONE)) or (seq1==3 and c:IsLocation(LOCATION_MZONE))   
	elseif seq2==4 then return (seq1==3 and c:IsLocation(LOCATION_SZONE)) or (seq1==4 and c:IsLocation(LOCATION_MZONE)) 
	else return false end 
	end 
end 
function c79083109.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()<=0 then return end 
	local tc=g:RandomSelect(tp,1):GetFirst() 
	local seq=tc:GetSequence() 
	local loc=0 
	if tc:IsLocation(LOCATION_MZONE) then loc=1 
	elseif tc:IsLocation(LOCATION_SZONE) then loc=2 end	
	Duel.HintSelection(Group.FromCards(tc)) 
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) 
	local x=0 
	if Duel.IsPlayerAffectedByEffect(p,79083110) and seq==0 and tc:IsLocation(LOCATION_MZONE) then 
	x=1 
	elseif Duel.IsPlayerAffectedByEffect(p,79083210) and seq==1 and tc:IsLocation(LOCATION_MZONE) then 
	x=1 
	elseif Duel.IsPlayerAffectedByEffect(p,79083310) and seq==2 and tc:IsLocation(LOCATION_MZONE) then 
	x=1 
	elseif Duel.IsPlayerAffectedByEffect(p,79083410) and seq==3 and tc:IsLocation(LOCATION_MZONE) then 
	x=1 
	elseif Duel.IsPlayerAffectedByEffect(p,79083510) and seq==4 and tc:IsLocation(LOCATION_MZONE) then 
	x=1 
	elseif Duel.IsPlayerAffectedByEffect(p,79083610) and seq==0 and tc:IsLocation(LOCATION_MZONE) then 
	x=1   
	elseif Duel.IsPlayerAffectedByEffect(p,79083710) and seq==1 and tc:IsLocation(LOCATION_SZONE) then 
	x=1 
	elseif Duel.IsPlayerAffectedByEffect(p,79083810) and seq==2 and tc:IsLocation(LOCATION_SZONE) then 
	x=1   
	elseif Duel.IsPlayerAffectedByEffect(p,79083910) and seq==3 and tc:IsLocation(LOCATION_SZONE) then 
	x=1 
	elseif Duel.IsPlayerAffectedByEffect(p,79083010) and seq==4 and tc:IsLocation(LOCATION_SZONE) then 
	x=1   
	elseif Duel.IsPlayerAffectedByEffect(p,79084010) and seq==5 and tc:IsLocation(LOCATION_SZONE) then 
	x=1 
	elseif Duel.IsPlayerAffectedByEffect(tp,79084110) and seq==5 and p==tp and tc:IsLocation(LOCATION_MZONE) then 
	x=1   
	elseif Duel.IsPlayerAffectedByEffect(tp,79084210) and seq==6 and p==tp and tc:IsLocation(LOCATION_MZONE) then 
	x=1 
	elseif Duel.IsPlayerAffectedByEffect(1-tp,79084110) and seq==6 and p~=tp and tc:IsLocation(LOCATION_MZONE) then 
	x=1 
	elseif Duel.IsPlayerAffectedByEffect(1-tp,79084210) and seq==5 and p~=tp and tc:IsLocation(LOCATION_MZONE) then 
	x=1 
	end
	if x==1 then 
	Duel.Hint(HINT_CARD,0,79083107)
	Duel.Damage(1-tp,800,REASON_EFFECT)
	end 
	while Duel.IsExistingMatchingCard(c79083109.dsfil,tp,0,LOCATION_ONFIELD,1,nil,seq,loc) do  
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()<=0 then return end 
	local tc=g:RandomSelect(tp,1):GetFirst()
	local seq=tc:GetSequence() 
	local loc=0 
	if tc:IsLocation(LOCATION_MZONE) then loc=1 
	elseif tc:IsLocation(LOCATION_SZONE) then loc=2 end   
	Duel.HintSelection(Group.FromCards(tc)) 
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end 
end 
function c79083109.lmttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c79083109.lmtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	--force mzone
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_EXTRA)
	e1:SetValue(c79083109.frcval)
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp)
end
function c79083109.frcval(e,c,fp,rp,r) 
	local tp=e:GetOwnerPlayer()
	local flag=0 
	if Duel.IsPlayerAffectedByEffect(tp,79083110) then 
	flag=bit.bor(flag,1) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083210) then 
	flag=bit.bor(flag,2) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083310) then 
	flag=bit.bor(flag,4) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083410) then 
	flag=bit.bor(flag,8) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083510) then 
	flag=bit.bor(flag,16) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083610) then 
	flag=bit.bor(flag,256) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083710) then 
	flag=bit.bor(flag,512) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083810) then 
	flag=bit.bor(flag,1024) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083910) then 
	flag=bit.bor(flag,2048) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083010) then 
	flag=bit.bor(flag,4096) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083010) then 
	flag=bit.bor(flag,8192) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083110) then 
	flag=bit.bor(flag,65536*1) 
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,79083210) then 
	flag=bit.bor(flag,65536*2) 
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,79083310) then 
	flag=bit.bor(flag,65536*4) 
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,79083410) then 
	flag=bit.bor(flag,65536*8) 
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,79083510) then 
	flag=bit.bor(flag,65536*16) 
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,79083610) then 
	flag=bit.bor(flag,65536*256) 
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,79083710) then 
	flag=bit.bor(flag,65536*512) 
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,79083810) then 
	flag=bit.bor(flag,65536*1024) 
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,79083910) then 
	flag=bit.bor(flag,65536*2048) 
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,79083010) then 
	flag=bit.bor(flag,65536*4096) 
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,79084010) then 
	flag=bit.bor(flag,65536*8192) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79084110) then 
	flag=bit.bor(flag,4194336) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79084210) then 
	flag=bit.bor(flag,2097216) 
	end 
	return flag 
end


