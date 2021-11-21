if not pcall(function() require("expansions/script/c16104200") end) then require("script/c16104200") end
local m,cm=rk.set(16104212,"CHURCH")
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e0=rkch.PenSpLimit(c,true)
	local e1=rsef.STF(c,EVENT_SUMMON_SUCCESS,{m,0},{1,m},"se,th","de,dsp",nil,nil,rsop.target(cm.thfilter(c),"th",LOCATION_DECK+LOCATION_GRAVE),cm.thop)
	local e2=rsef.RegisterClone(c,e1,"code",EVENT_SPSUMMON_SUCCESS)
	local e3=rkch.PenAdd(c,{m,0},{1,m+1},{rscost.lpcost(1000),nil,cm.target,cm.op},false)
	local e4=rkch.DoubleTriFun(c)
	local e5=rkch.MonzToPen(c,m,EVENT_LEAVE_FIELD,true)
end
function cm.thfilter(c)
	return c:IsSetCard(0x5ccd) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	if rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,{}) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetValue(1)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		e2:SetOperation(cm.regop)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsSummonPlayer(tp) and tc:IsSummonType(SUMMON_TYPE_ADVANCE) then
		e:GetLabelObject():Reset()
		e:Reset()
	end
end
function cm.thfilter1(c,e,tp)
	return c:IsSetCard(0x3ccd) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_EXTRA,0,1,nil) end
	e:SetCategory(CATEGORY_TOHAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_EXTRA)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_EXTRA,0,1,1,nil)
		if sg then
			local tc=sg:GetFirst()
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,4))
			if tc.dff==true then
				tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+0x7e0000,EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_OATH,0,0,aux.Stringid(16104200,3))
			end
		end
	end
end