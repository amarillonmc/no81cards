--天基兵器 湿婆之眼
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c33330048") end) then require("script/c33330048") end
function cm.initial_effect(c)
	local e1,e2 = Rule_SpaceWeapon.initial(c,m,cm.op)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,c)
	local op={}
	local os={}
	for i=2,4,1 do
		if i==2 and Duel.GetFieldGroupCount(tp,0,2)>0 then
			op[1]=aux.Stringid(m,1)
			os[1]=i
		elseif i~=2 and Duel.GetMatchingGroupCount(Card.IsType,tp,0,i*4,nil,TYPE_SPELL+TYPE_TRAP)>0 then
			op[#op+1]=aux.Stringid(m,i-1)
			os[#os+1]=i
		end
	end
	if #op==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	op = #op==1 and os[1] or os[Duel.SelectOption(tp,table.unpack(op))+1]
	Duel.BreakEffect()
	os = Duel.GetMatchingGroup(Card.IsType,tp,0,op*(op==2 and 1 or 4),nil,TYPE_SPELL+TYPE_TRAP)
	if op==2 then Duel.ConfirmCards(tp,Duel.GetFieldGroup(tp,0,LOCATION_HAND)) end
	if #os>0 then Duel.Remove(os,POS_FACEUP,REASON_EFFECT) end
end
