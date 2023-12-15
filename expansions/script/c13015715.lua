--深海姬·多爪
function c13015715.initial_effect(c)
	--tg dr sr 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW+CATEGORY_POSITION) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetLabel(13015713)
	e1:SetCountLimit(1,13015715)  
	e1:SetCost(c13015715.tdrcost)
	e1:SetTarget(c13015715.tdrtg) 
	e1:SetOperation(c13015715.tdrop)
	c13015715.tdr_effect=e1   
	c:RegisterEffect(e1) 
	--splimit 
   
	--draw
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,23015715)
	e3:SetTarget(c13015715.drtg)
	e3:SetOperation(c13015715.drop)
	c:RegisterEffect(e3)  
end
function c13015715.op(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local lv=c:GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
 lev=Duel.AnnounceLevel(tp,1,8,lv)
 local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lev)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end


function c13015715.tdrcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end 
	Duel.ConfirmCards(1-tp,e:GetHandler()) 
	Duel.ShuffleHand(tp) 
end  
function c13015715.tdrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) or Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCanChangePosition() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) or Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)  
end 
function c13015715.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_AQUA)  
end 
function c13015715.splimit(e,c)
return not (c:IsRace(RACE_AQUA) and c:IsAttribute(ATTRIBUTE_WATER))
end
function c13015715.tdrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.SendtoGrave(c,REASON_EFFECT+REASON_DISCARD)
	 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c13015715.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)  
   
		local b1=Duel.IsPlayerCanDraw(tp,1) 
		local b2=Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCanChangePosition() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)   
		local b3=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) 
		local op=3 
		if b1 and b2 and b3 then 
		op=Duel.SelectOption(tp,aux.Stringid(13015715,1),aux.Stringid(13015715,2),aux.Stringid(13015715,3))
		elseif b1 and b2 then 
		op=Duel.SelectOption(tp,aux.Stringid(13015715,1),aux.Stringid(13015715,2))
		elseif b1 and b3 then   
		op=Duel.SelectOption(tp,aux.Stringid(13015715,1),aux.Stringid(13015715,3))
		if op==1 then op=op+1 end 
		elseif b2 and b3 then   
		op=Duel.SelectOption(tp,aux.Stringid(13015715,2),aux.Stringid(13015715,3))+1
		elseif b1 then 
		op=Duel.SelectOption(tp,aux.Stringid(13015715,1)) 
		elseif b2 then 
		op=Duel.SelectOption(tp,aux.Stringid(13015715,2))+1 
		elseif b3 then 
		op=Duel.SelectOption(tp,aux.Stringid(13015715,2))+2  
		end 
		if op==0 then 
			Duel.Draw(tp,1,REASON_EFFECT)
		elseif op==1 then 
		   
				local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsFaceup() and c:IsCanChangePosition() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil) 
				Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)   
			
		elseif op==2 then 
			 
				local sg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil) 
				Duel.ChangePosition(sg,POS_FACEDOWN)   
				local tc=sg:GetFirst() 
				 
				tc:CancelToGrave()  
				
				Duel.RaiseEvent(sg,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) 
			
		end 
	end 

function c13015715.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c13015715.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT) 
end
