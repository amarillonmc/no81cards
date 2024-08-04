--[[
最后的决意
Final Determination
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	local e1=aux.AddRitualProcEqualCode(c,112312328,nil,nil,s.mfilter,false,s.extraop,s.extratg)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_RELEASE|CATEGORY_TOGRAVE)
end
function s.mfilter(c)
	return c:IsRace(RACE_MACHINE)
end
function s.rlfilter(c)
	return c:IsLevel(4) and c:IsRace(RACE_MACHINE) and c:IsReleasableByEffect()
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetPossibleOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_MZONE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.extraop(e,tp,eg,ep,ev,re,r,rp,tc,mat)
	local rg=Duel.Group(s.rlfilter,tp,LOCATION_MZONE,0,nil)
	local tg=Duel.Group(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if #rg>0 and #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local rgs=Duel.Select(HINTMSG_RELEASE,false,tp,s.rlfilter,tp,LOCATION_MZONE,0,1,#tg,nil)
		if #rgs>0 then
			local ct=Duel.Release(rgs,REASON_EFFECT)
			if ct>0 then
				local tgs=Duel.Select(HINTMSG_TOGRAVE,false,tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,ct,ct,nil)
				if #tgs>0 then
					Duel.HintSelection(tgs)
					Duel.SendtoGrave(tgs,REASON_EFFECT)
				end
			end
		end
	end
end
