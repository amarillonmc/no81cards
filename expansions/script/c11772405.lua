--冥界王后 波瑟芬妮
local s,id,o=GetID()
function s.initial_effect(c)
	--回到手卡
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS,EVENT_FLIP)
	--特殊召唤	
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--改变效果    
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.chcon)
	e2:SetTarget(s.chtg)
	e2:SetOperation(s.chop)
	c:RegisterEffect(e2)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(aux.Stringid(id,4))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(s.hspcon)
	e1:SetOperation(s.hspop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e1,tp)
end
function s.hspfilter(c,e,tp)
	return c:IsSetCard(0x6c76) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.hspfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.hspfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    e:SetLabel(0)
    local ch=Duel.GetCurrentChain()
    local te=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_EFFECT)
    if te and te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsType(TYPE_SPIRIT) then
    	e:SetCategory(CATEGORY_REMOVE)
        Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)        
    end
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
    local ch=Duel.GetCurrentChain()
    local te=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_EFFECT)
    if te and te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsType(TYPE_SPIRIT) then
    	local c=e:GetHandler()
    	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if hg:GetCount()>0 then
			Duel.ConfirmCards(tp,hg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sc=hg:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil):GetFirst()
			if sc then
            	Duel.HintSelection(Group.FromCards(sc))
				if Duel.Remove(sc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
					local fid=c:GetFieldID()
                	sc:RegisterFlagEffect(id,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1,fid)
                	local e1=Effect.CreateEffect(c)
                    e1:SetDescription(aux.Stringid(id,2))
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
					e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
					e1:SetCountLimit(1)
                	e1:SetLabel(fid)
					e1:SetLabelObject(sc)
					e1:SetCondition(s.retcon)
					e1:SetOperation(s.retop)
					if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
						e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
						e1:SetValue(Duel.GetTurnCount())
					else
						e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
						e1:SetValue(0)
					end
					Duel.RegisterEffect(e1,tp)
               end
               Duel.ShuffleHand(1-tp)    			            
            end    
		end    
    end
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(aux.Stringid(id,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(s.drcon)
	e1:SetOperation(s.drop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e1,tp)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.IsPlayerCanDraw(tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp or Duel.GetTurnCount()==e:GetValue() then return false end
	return e:GetLabelObject():GetFlagEffectLabel(id)==e:GetLabel()
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
end