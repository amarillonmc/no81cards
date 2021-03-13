if not pcall(function() require("expansions/script/c33700650") end) then require("script/c33700650") end
--破天神狐 壹贰〇〇·六九七七七七六五
local m=33700651
local cm=_G["c"..m]
cm.named_with_ptsh=true
function cm.initial_effect(c)
	local e1=sr_ptsh.Cmeffect(c,m)
	
	local e2=sr_ptsh.efeffect(c,m,CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER,EVENT_DAMAGE,EFFECT_FLAG_DELAY)
	local e4=sr_ptsh.efeffect(c,m,CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER,EVENT_BATTLE_DAMAGE,EFFECT_FLAG_DELAY)

	local e3=sr_ptsh.opeffect(c,m)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetTurnPlayer()==1-tp
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev*2)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Recover(tp,ev*2,REASON_EFFECT)>0  and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.geteffect(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(cm.val)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET)
	c:RegisterEffect(e3)
end
function cm.val(e,re,dam,r,rp,rc)
	return dam/2
end